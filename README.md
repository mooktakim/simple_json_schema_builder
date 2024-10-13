# SimpleJsonSchemaBuilder

A simple, yet powerful DSL to help you create JSON Schemas in Ruby effortlessly.

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

**Note:** `simple_json_schema_builder` depends on [multi_json](https://github.com/intridea/multi_json) for JSON serialization, which allows you to choose your preferred JSON library.
It is recommended to use `oj` as its really fast.

## Usage

Here's an example demonstrating how to use `SimpleJsonSchemaBuilder`:

```ruby
class UserSchema < SimpleJsonSchemaBuilder::Base
  object do
    string :name, required: true, examples: ["John Doe"]
    integer :age, required: false, examples: [30]
    boolean :is_active, required: false, examples: [true, false]
    string :role, enum: ["admin", "user", "guest"], examples: ["user"]
    string :tags, array: true, examples: ["ruby", "json"]

    object :contact_info, required: true do
      string :email, required: true, examples: ["johndoe@example.com"]
      string :phone_number, required: false, examples: ["123-456-7890"]
    end

    object :addresses, array: true do
      string :street, required: true, examples: ["123 Main St"]
      string :city, required: true, examples: ["Springfield"]
      string :country, required: true, examples: ["USA"]
    end

    object :account_preferences, schema: AccountPreferences
  end
end

class AccountPreferences < SimpleJsonSchemaBuilder::Base
  object do
    boolean :receive_newsletter, required: false, examples: [true]
    string :preferred_language, enum: ["en", "es", "fr"], required: true, examples: ["en"]
  end
end
```

The above code will serialize `UserSchema.schema` to the following JSON Schema:

```json
{
  "type": "object",
  "required": ["name", "contact_info"],
  "properties": {
    "name": {
      "type": "string",
      "examples": ["John Doe"]
    },
    "age": {
      "type": "integer",
      "examples": [30]
    },
    "is_active": {
      "type": "boolean",
      "examples": [true, false]
    },
    "role": {
      "type": "string",
      "examples": ["user"],
      "enum": ["admin", "user", "guest"]
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string",
        "examples": ["ruby", "json"]
      }
    },
    "contact_info": {
      "type": "object",
      "required": ["email"],
      "properties": {
        "email": {
          "type": "string",
          "examples": ["johndoe@example.com"]
        },
        "phone_number": {
          "type": "string",
          "examples": ["123-456-7890"]
        }
      }
    },
    "addresses": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["street", "city", "country"],
        "properties": {
          "street": {
            "type": "string",
            "examples": ["123 Main St"]
          },
          "city": {
            "type": "string",
            "examples": ["Springfield"]
          },
          "country": {
            "type": "string",
            "examples": ["USA"]
          }
        }
      }
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mooktakim/simple_json_schema_builder>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mooktakim/simple_json_schema_builder/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleJsonSchemaBuilder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mooktakim/simple_json_schema_builder/blob/main/CODE_OF_CONDUCT.md).
