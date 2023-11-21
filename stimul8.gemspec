require_relative "lib/stimul8/version"

Gem::Specification.new do |spec|
  spec.name = "stimul8"
  spec.version = Stimul8::VERSION
  spec.authors = ["Rahoul Baruah"]
  spec.email = ["baz@collabor8online.co.uk"]
  spec.homepage = "https://github.com/Collabor8Online/stimul8"
  spec.summary = "Stimulus based components for Rails"
  spec.description = "All the advantages of client-side components, but with minimal Javascript plus server-side rendering"
  spec.license = "LGPL"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Collabor8Online/stimul8"
  spec.metadata["changelog_uri"] = "https://github.com/Collabor8Online/stimul8/commits/main"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.5"
  spec.add_dependency "builder"
  spec.add_dependency "securerandom"
  spec.add_dependency "stimulus-rails"
end
