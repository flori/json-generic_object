# frozen_string_literal: true
require_relative 'test_helper'

class JSONGenericObjectTest < Test::Unit::TestCase
  def setup
    @go = JSON::GenericObject[ :a => 1, :b => 2 ]
  end

  def test_attributes
    assert_equal 1, @go.a
    assert_equal 1, @go[:a]
    assert_equal 2, @go.b
    assert_equal 2, @go[:b]
    assert_nil @go.c
    assert_nil @go[:c]
  end

  def test_parse_json
    assert_kind_of Hash,
      JSON('{ "json_class": "JSON::GenericObject", "a": 1, "b": 2 }')
    parsed = JSON('{ "a": { "b": 2 } }', :object_class => JSON::GenericObject)
    assert_equal JSON::GenericObject[:a => JSON::GenericObject[:b => 2]], parsed
    assert_kind_of JSON::GenericObject, parsed
    assert_equal 2, parsed.a.b
  end

  def test_from_hash
    result  = JSON::GenericObject.from_hash(
      :foo => { :bar => { :baz => true }, :quux => [ { :foobar => true } ] })
    assert_kind_of JSON::GenericObject, result.foo
    assert_kind_of JSON::GenericObject, result.foo.bar
    assert_equal   true, result.foo.bar.baz
    assert_kind_of JSON::GenericObject, result.foo.quux.first
    assert_equal   true, result.foo.quux.first.foobar
    assert_equal   true, JSON::GenericObject.from_hash(true)
  end

  def test_json_generic_object_load
    empty = JSON::GenericObject.load(nil)
    assert_kind_of JSON::GenericObject, empty
    simple_json = '{"json_class":"JSON::GenericObject","hello":"world"}'
    simple = JSON::GenericObject.load(simple_json)
    assert_kind_of JSON::GenericObject, simple
    assert_equal "world", simple.hello
    converting = JSON::GenericObject.load('{ "hello": "world" }')
    assert_kind_of JSON::GenericObject, converting
    assert_equal "world", converting.hello

    json = JSON::GenericObject.dump(JSON::GenericObject[:hello => 'world'])
    assert_equal JSON(json), JSON('{"json_class":"JSON::GenericObject","hello":"world"}')
  end
end
