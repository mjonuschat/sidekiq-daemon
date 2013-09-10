# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/daemon/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-daemon"
  spec.version       = Sidekiq::Daemon::VERSION
  spec.authors       = ["Morton Jonuschat"]
  spec.email         = ["yabawock@gmail.com"]
  spec.description   = %q{Sidekiq process daemonization for JRuby}
  spec.summary       = %q{Run Sidekiq as a daemon using JRuby. Sidekiq will start a new process in the background and detach from the terminal.}
  spec.homepage      = "https://github.com/yabawock/sidekiq-daemon"
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             "sidekiq", "~> 2.7"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
