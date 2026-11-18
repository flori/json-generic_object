# -*- encoding: utf-8 -*-
# stub: json-generic_object 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "json-generic_object".freeze
  s.version = "0.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "1980-01-02"
  s.description = "Provides JSON::GenericObject for method-style access to JSON\nobjects. Previously part of the json gem, extracted for\njson 3.0.0.\n".freeze
  s.email = "flori@ping.de".freeze
  s.extra_rdoc_files = ["README.md".freeze, "lib/json-generic_object/version.rb".freeze, "lib/json/generic_object.rb".freeze]
  s.files = [".envrc".freeze, ".gitignore".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "VERSION".freeze, "json-generic_object.gemspec".freeze, "lib/json-generic_object/version.rb".freeze, "lib/json/generic_object.rb".freeze, "test/json_generic_object_test.rb".freeze, "test/test_helper.rb".freeze]
  s.homepage = "https://github.com/flori/json-generic_object".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "Json-genericObject - JSON::GenericObject extracted from the json gem.".freeze, "--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "4.0.24".freeze
  s.summary = "JSON::GenericObject extracted from the json gem.".freeze
  s.test_files = ["test/json_generic_object_test.rb".freeze, "test/test_helper.rb".freeze]

  s.specification_version = 4

  s.add_development_dependency(%q<gem_hadar>.freeze, [">= 2.24.1".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 1.3".freeze])
  s.add_runtime_dependency(%q<json>.freeze, [">= 2.0".freeze])
  s.add_runtime_dependency(%q<ostruct>.freeze, [">= 0".freeze])
end
