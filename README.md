# SimpleJsonSchemaBuilder

A simple DSL to help you write JSON Schema in ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_json_schema_builder'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install simple_json_schema_builder
```

`simple_json_schema_builder` depends on [multi_json](https://github.com/intridea/multi_json) to serialize to JSON, which allows you to pick your favourite JSON library, `oj` is recommended as its fast.

## Usage

```ruby
class MySchema < SimpleJsonSchemaBuilder::Base
  object do
    string :string_test, required: false, examples: "blue while"
    boolean :boolean_test, examples: [ "blah", "bleh" ]
    string :str_array_test, array: true
    string :string_enums, enum: [ "test1", "test2" ]
    string :string_enum_arrays, array: true, enum: [ "test1", "test2" ]

    object :other_info, required: true do
      string :string_test, required: true
      boolean :boolean_test
    end

    object :other_info_arr, array: true do
      string :string_test, required: true
      boolean :boolean_test
    end

    object :subschema_arr, array: true, schema: Subschema
    object :subschema, schema: Subschema
  end
end

class Subschema < SimpleJsonSchemaBuilder::Base
  object do
    string :test1
    integer :test2, required: true
  end
end
```

Will serialize to:

```json
{
  "type": "object",
  "required": ["other_info"],
  "properties": {
    "string_test": {
      "type": "string",
      "examples": ["blue while"]
    },
    "boolean_test": {
      "type": "boolean",
      "examples": ["blah", "bleh"]
    },
    "str_array_test": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "string_enums": {
      "type": "string",
      "enum": ["test1", "test2"]
    },
    "string_enum_arrays": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["test1", "test2"]
      }
    },
    "other_info": {
      "type": "object",
      "required": ["string_test"],
      "properties": {
        "string_test": {
          "type": "string"
        },
        "boolean_test": {
          "type": "boolean"
        }
      }
    },
    "other_info_arr": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["string_test"],
        "properties": {
          "string_test": {
            "type": "string"
          },
          "boolean_test": {
            "type": "boolean"
          }
        }
      }
    },
    "subschema_arr": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["test2"],
        "properties": {
          "test1": {
            "type": "string"
          },
          "test2": {
            "type": "integer"
          }
        }
      }
    },
    "subschema": {
      "type": "object",
      "required": ["test2"],
      "properties": {
        "test1": {
          "type": "string"
        },
        "test2": {
          "type": "integer"
        }
      }
    }
  }
}
```

TODO: needs sensible examples

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mooktakim/simple_json_schema_builder>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mooktakim/simple_json_schema_builder/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleJsonSchemaBuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mooktakim/simple_json_schema_builder/blob/main/CODE_OF_CONDUCT.md).
