# frozen_string_literal: true

require 'json'
require 'ostruct'

module JSON
  # Provides a generic object for method-style access to JSON data.
  #
  # Parsed JSON objects can be converted into instances of this class,
  # allowing attribute access via `object.foo` instead of
  # `object["foo"]`. Nested hashes and arrays are recursively converted.
  #
  # This class was previously part of the {file:README.md `json` gem}
  # and was extracted into its own gem for json 3.0.0.
  #
  # @example Creating from a hash
  #   go = JSON::GenericObject[a: 1, b: 2]
  #   go.a   #=> 1
  #   go.b   #=> 2
  #
  # @example Parsing JSON with method access
  #   result = JSON('{"name":"Jane"}', object_class: JSON::GenericObject)
  #   result.name  #=> "Jane"
  class GenericObject < OpenStruct
    class << self
      # Returns the key name used to mark the class identity of a
      # serialized GenericObject.
      #
      # On json 2.x this delegates to `JSON.create_id`; on json 3.x
      # (where `create_id` was removed) it falls back to the literal
      # string `"json_class"`.
      #
      # Used internally by #json_create and #as_json to read or write
      # the class tag in the serialized output.
      #
      # @return [String] the key name (e.g. `"json_class"`)
      def json_create_id
        if ::JSON.respond_to?(:create_id)
          JSON.create_id
        else
          'json_class'
        end
      end

      # Creates a new GenericObject from a hash of attributes.
      #
      # @return [GenericObject] a new instance
      #
      # @example
      #   go = JSON::GenericObject[a: 1, b: 2]
      #   go.a  #=> 1
      alias [] new

      # Checks whether GenericObject instances can be created during
      # JSON parsing via the `json_class` / `json_create` protocol.
      #
      # @note The `create_additions` option was removed in json 3.0,
      #   so the json parser no longer consults this flag or calls
      #   #json_create. This method is retained for API compatibility
      #   and for use with custom serializers.
      #
      # @return [Boolean, nil] the current creatable flag
      def json_creatable?
        @json_creatable
      end

      # Sets whether GenericObject instances can be created during
      # JSON parsing. See #json_creatable?.
      #
      # @note No effect with json >= 3.0, as the parser no longer
      #   supports `create_additions`. Retained for API compatibility.
      #
      # @param value [Boolean] whether to enable json_create
      # @return [Boolean] the value that was set
      attr_writer :json_creatable

      # Creates a GenericObject from a parsed JSON hash.
      #
      # Part of the `json_class` / `json_create` deserialization
      # protocol. The `json_class` key is stripped before
      # construction.
      #
      # @note The json parser no longer calls this method since
      #   `create_additions` was removed in json 3.0. It is retained
      #   for use with custom serializers.
      #
      # @param data [Hash] the parsed JSON object
      # @return [GenericObject] a new instance
      def json_create(data)
        data = data.dup
        data.delete JSON::GenericObject.json_create_id
        self[data]
      end

      # Recursively converts a plain Ruby data structure into a tree
      # of GenericObject instances.
      #
      # Hashes become GenericObjects, arrays are mapped element-wise,
      # and scalar values (strings, numbers, booleans, `nil`) are
      # returned unchanged.
      #
      # @param object [Object] the data structure to convert
      # @return [GenericObject, Array, Object] the converted structure
      #
      # @example
      #   result = JSON::GenericObject.from_hash(
      #     foo: { bar: { baz: true } }
      #   )
      #   result.foo.bar.baz  #=> true
      def from_hash(object)
        case
        when object.respond_to?(:to_hash)
          result = new
          object.to_hash.each do |key, value|
            result[key] = from_hash(value)
          end
          result
        when object.respond_to?(:to_ary)
          object.to_ary.map { |a| from_hash(a) }
        else
          object
        end
      end

      # Parses a JSON string into a GenericObject.
      #
      # Convenience wrapper around `JSON.load` that sets
      # `object_class` to GenericObject. If the source is `nil` or
      # parses to `nil`, an empty GenericObject is returned.
      #
      # @param source [String, nil] JSON string to parse
      # @param proc [Proc, nil] optional value transformation block
      # @param opts [Hash] additional keyword options for JSON.load
      # @return [GenericObject] the parsed object
      #
      # @example
      #   go = JSON::GenericObject.load('{"hello":"world"}')
      #   go.hello  #=> "world"
      def load(source, proc = nil, opts = {})
        result =
          if ::JSON.method(:load).parameters.any? { |pt,| pt == :keyrest }
            ::JSON.load(source, proc, **opts.merge(:object_class => self))
          else
            ::JSON.load(source, proc, opts.merge(:object_class => self))
          end
        result.nil? ? new : result
      end

      # Serializes an object to a JSON string.
      #
      # Thin wrapper around `JSON.dump` for symmetry with #load.
      #
      # @param obj [Object] the object to serialize
      # @param args [Array] additional arguments passed to JSON.dump
      # @return [String] the JSON representation
      def dump(obj, *args)
        ::JSON.dump(obj, *args)
      end
    end
    self.json_creatable = false

    # Returns the internal attribute table as a plain Hash.
    #
    # @return [Hash] the underlying key/value storage
    def to_hash
      table
    end

    # Merges another object into a new GenericObject.
    #
    # Attributes from +other+ are merged under +self+; on key
    # conflicts, +self+ wins.
    #
    # @param other [Object] an object responding to `to_hash`
    # @return [GenericObject] a new merged instance
    def |(other)
      self.class[other.to_hash.merge(to_hash)]
    end

    # Returns the JSON-serializable representation of this object.
    #
    # Includes the `json_class` marker in the output. Note that the
    # json parser no longer consumes this marker (the
    # `create_additions` option was removed in json 3.0), so
    # round-tripping through `JSON.parse` will yield a plain Hash
    # unless a custom serializer handles the tag.
    #
    # @return [Hash] a hash with `json_class` and all attributes
    def as_json(*)
      { JSON::GenericObject.json_create_id => self.class.name }.merge to_hash
    end

    # Serializes this GenericObject to a JSON string.
    #
    # Delegates to #as_json and then calls `to_json` on the resulting
    # hash, embedding the `json_class` marker automatically.
    #
    # @param a [Array] additional arguments passed through
    # @return [String] the JSON representation
    #
    # @example
    #   go = JSON::GenericObject[hello: 'world']
    #   go.to_json
    #   #=> '{"json_class":"JSON::GenericObject","hello":"world"}'
    def to_json(*a)
      as_json.to_json(*a)
    end
  end unless defined? JSON::GenericObject
end
