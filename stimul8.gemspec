require_relative "lib/stimul8/version"

Gem::Specification.new do |spec|
  spec.name = "stimul8"
  spec.version = Stimul8::VERSION
  spec.authors = ["Rahoul Baruah"]
  spec.email = ["baz@collabor8online.co.uk"]
  spec.homepage = "https://www.collabor8online.co.uk"
  spec.summary = "Stimulus based components for Rails"
  spec.description = "Stimulus based components for Rails"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.5"
  spec.add_dependency "markaby"
  spec.add_dependency "securerandom"
end
