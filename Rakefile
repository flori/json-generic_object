require 'gem_hadar'

GemHadar do
  name        'json-generic_object'
  path_module 'JSON::GenericObject'
  module_type 'class'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "https://github.com/flori/#{name}"
  summary     'JSON::GenericObject extracted from the json gem.'
  description <<~EOT
    Provides JSON::GenericObject for method-style access to JSON
    objects. Previously part of the json gem, extracted for
    json 3.0.0.
  EOT
  test_dir    'test'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.AppleDouble',
    '.bundle', '.yardoc', 'tags', 'cscope.out', 'doc'
  readme      'README.md'

  required_ruby_version '>= 2.7'
  dependency  'json', '>= 2.0'
  dependency  'ostruct'
  development_dependency 'rake'
  development_dependency 'test-unit'
  development_dependency 'simplecov', '~> 1.3'
  development_dependency 'debug'
  licenses << 'MIT'
end
