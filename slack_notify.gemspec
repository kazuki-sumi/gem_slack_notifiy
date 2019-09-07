
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slack_notify/version"

Gem::Specification.new do |spec|
  spec.name          = "slack_notify"
  spec.version       = SlackNotify::VERSION
  spec.authors       = ["鷲見和希"]
  spec.email         = ["cs5200@icloud.com"]

  spec.summary       = %q{gemの動きをしるために写経}
  spec.description   = %q{gemの動きをしるために写経}
  spec.homepage      = "https://www.google.com"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry", "~> 0.12.2"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
