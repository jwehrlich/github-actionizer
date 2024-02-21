require_relative "lib/github/actionizer"

Gem::Specification.new do |spec|
  spec.name              = 'github-actionizer'
  spec.version           = Github::Actionizer::VERSION
  spec.platform          = Gem::Platform::RUBY
  spec.summary           = 'Docker Compose + Github Action Runners = Easily create and scale your action runners'
  spec.description       = 'Docker Compose + Github Action Runners = Easily create and scale your action runners'
  spec.authors           = ['Jason W. Ehrlich']
  spec.email             = ['jwehrlich@outlook.com.com']
  spec.homepage          = 'http://github.com/jwehrlich/github-actionizer'
  spec.license           = 'GPL-3.0'
  spec.files             = Dir.glob("{bin,docker,lib}/**/*")
  spec.require_path      = 'lib'
  spec.bindir            = 'bin'
  spec.executables       = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.metadata = {
    "bug_tracker_uri"   => "#{spec.homepage}/issues",
    "changelog_uri"     => "#{spec.homepage}/releases",
    "documentation_uri" => "#{spec.homepage}/wiki",
    "homepage_uri"      => "#{spec.homepage}",
    "source_code_uri"   => "#{spec.homepage}/tree/main/",
    "wiki_uri"          => "#{spec.homepage}/wiki"
  }
end
