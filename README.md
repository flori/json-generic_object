# JSON::GenericObject 🧊

## Description 📝

This gem provides `JSON::GenericObject` for method-style access to JSON data.
Instead of drilling into nested hashes with `obj["a"]["b"]["c"]`, you can
access attributes directly: `obj.a.b.c`. 🚀

This class was previously part of the [`json` gem](https://github.com/ruby/json)
and was extracted into its own gem for json 3.0.0.

## Installation 📦

```bash
gem install json-generic_object
```

Or add it to your Gemfile:

```ruby
gem 'json-generic_object'
```

Then `require 'json/generic_object'` in your application. The `json` (>= 2.0)
and `ostruct` gems are pulled in automatically as dependencies.

## Usage 🛠️

### Creating from a hash

```ruby
go = JSON::GenericObject[a: 1, b: 2]
go.a  #=> 1
go.b  #=> 2
```

### Parsing JSON with method access

```ruby
result = JSON('{"name":"Jane","address":{"city":"Berlin"}}',
  object_class: JSON::GenericObject
)
result.name     #=> "Jane"
result.address.city  #=> "Berlin"
```

### Serializing with `json_class`

`to_json` embeds a `json_class` marker in the output. Note that the json
parser (>= 3.0) no longer consumes this marker — re-parsing yields a plain
`Hash` unless you pass `object_class:`:

```ruby
go = JSON::GenericObject[hello: 'world']
json = go.to_json
# => '{"json_class":"JSON::GenericObject","hello":"world"}'

# Re-parse with method access:
parsed = JSON.parse(json, object_class: JSON::GenericObject)
parsed.hello  #=> "world"
parsed.class  #=> JSON::GenericObject
```

### Converting plain data structures

`from_hash` recursively converts hashes and arrays into a tree of
`GenericObject` instances:

```ruby
result = JSON::GenericObject.from_hash(
  foo: { bar: { baz: true }, quux: [{ foobar: true }] }
)
result.foo.bar.baz        #=> true
result.foo.quux.first.foobar  #=> true
```

### Merging

The `|` operator merges two objects, with the receiver's attributes
taking precedence on key conflicts:

```ruby
a = JSON::GenericObject[x: 1, y: 2]
b = JSON::GenericObject[y: 99, z: 3]
merged = b | a
merged.x  #=> 1
merged.y  #=> 2   (a wins)
merged.z  #=> 3
```

## API Reference 📚

### Class Methods

- **`[]`** — Creates a new instance from a hash of attributes
- **`json_create(data)`** — Deserialization hook (deprecated: the json
  3.0+ parser no longer calls this)
- **`from_hash(object)`** — Recursively converts a data structure
- **`load(source, proc, opts)`** — Parses a JSON string into a GenericObject
- **`dump(obj, *args)`** — Serializes an object to a JSON string
- **`json_creatable?`** / **`json_creatable=`** — Toggle the `json_class`
  reconstruction protocol (defaults to `false`)

### Instance Methods

- **`to_hash`** — Returns the internal attribute table as a plain Hash
- **`|(other)`** — Merges another object into a new GenericObject
- **`as_json`** — Returns the JSON-serializable representation with `json_class`
- **`to_json`** — Serializes this object to a JSON string

## Download 📥

The homepage of this library is located at

* https://github.com/flori/json-generic_object

## Author 👨‍💻

[Florian Frank](mailto:flori@ping.de)

## License 📄

This software is licensed under the [MIT license](LICENSE).
