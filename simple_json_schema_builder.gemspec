# frozen_string_literal: true

require_relative "lib/simple_json_schema_builder/version"

Gem::Specification.new do |spec|
  spec.name = "simple_json_schema_builder"
  spec.version = SimpleJsonSchemaBuilder::VERSION
  spec.authors = ["Mooktakim Ahmed"]
  spec.email = ["mooktakim@fluxter.co.uk"]

  spec.summary = "JSON Schema builder with simple DSL."
  spec.description = "Build JSON Schema with simple ruby code, with objects and clean DSL."
  spec.homepage = "https://github.com/mooktakim/simple_json_schema_builder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mooktakim/simple_json_schema_builder"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "multi_json", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.platform = Gem::Platform::RUBY
end
