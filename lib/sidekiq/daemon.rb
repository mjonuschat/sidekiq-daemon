require "sidekiq/daemon/version"
require "sidekiq/cli"

module Sidekiq
  module Daemon
    def self.included(base)
      base.class_eval do
        alias_method :initialize_without_restart_data, :initialize
        alias_method :initialize, :initialize_with_restart_data

        alias_method :daemonize_process, :daemonize
        # alias_method :daemonize, :start_daemon
        def daemonize
          if defined?(JRUBY_VERSION)
            daemonize_jruby
          else
            daemonize_process
          end
        end

      end
    end

    def initialize_with_restart_data
      initialize_without_restart_data
      generate_restart_data
    end

    def daemonize_jruby
      return unless options[:daemon]

      raise ArgumentError, "You really should set a logfile if you're going to daemonize" unless options[:logfile]

      require 'sidekiq/daemon/jruby'
      already_daemon = false
      already_daemon = Sidekiq::Daemon::JRuby.daemon_init
      if already_daemon
        Sidekiq::Daemon::JRuby.perm_daemonize
      else
        pid = nil

        Signal.trap "SIGUSR2" do
          logger.info "Started new sidekiq process #{pid} as daemon..."

          # Must use exit! so we don't unwind and run the ensures
          # that will be run by the new child (such as deleting the
          # pidfile)
          exit!(true)
        end

        Signal.trap "SIGCHLD" do
          logger.info "Error starting new sidekiq process as daemon, exitting"
          exit 1
        end

        pid = Sidekiq::Daemon::JRuby.daemon_start(@restart_dir, @restart_argv)
        sleep
      end
    end

    def generate_restart_data
      # Use the same trick as unicorn, namely favor PWD because
      # it will contain an unresolved symlink, useful for when
      # the pwd is /data/releases/current.
      if dir = ENV['PWD']
        s_env = File.stat(dir)
        s_pwd = File.stat(Dir.pwd)

        if s_env.ino == s_pwd.ino and s_env.dev == s_pwd.dev
          @restart_dir = dir
        end
      end

      @restart_dir ||= Dir.pwd

      @original_argv = ARGV.dup

      if defined? Rubinius::OS_ARGV
        @restart_argv = Rubinius::OS_ARGV
      else
        require 'rubygems'

        # if $0 is a file in the current directory, then restart
        # it the same, otherwise add -S on there because it was
        # picked up in PATH.
        #
        if File.exists?($0)
          arg0 = [Gem.ruby, $0]
        else
          arg0 = [Gem.ruby, "-S", $0]
        end

        # Detect and reinject -Ilib from the command line
        lib = File.expand_path "lib"
        arg0[1,0] = ["-I", lib] if $:[0] == lib

        @restart_argv = arg0 + ARGV
      end
    end
  end
end
Sidekiq::CLI.send(:include, Sidekiq::Daemon)