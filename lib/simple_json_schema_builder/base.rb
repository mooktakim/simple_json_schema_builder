# frozen_string_literal: true

require "multi_json"

module SimpleJsonSchemaBuilder
  class Base
    def self.object(&block)
      @schema ||= Base.new
      @schema.instance_eval(&block)
    end

    def self.schema
      @schema.schema
    end

    def self.to_json
      MultiJson.dump(schema)
    end

    def initialize
      @properties = {}
      @required_key_names = []
    end

    def string(key_name, required: false, title: nil, description: nil, array: false, examples: [], enum: nil)
      add_required(key_name, required)
      add_property("string", key_name, title: title, description: description, examples: examples, enum: enum)
      add_array(key_name, array)
    end

    def integer(key_name, required: false, title: nil, description: nil, array: false, examples: [], enum: nil)
      add_required(key_name, required)
      add_property("integer", key_name, title: title, description: description, examples: examples, enum: enum)
      add_array(key_name, array)
    end

    def number(key_name, required: false, title: nil, description: nil, array: false, examples: [], enum: nil)
      add_required(key_name, required)
      add_property("number", key_name, title: title, description: description, examples: examples, enum: enum)
      add_array(key_name, array)
    end

    def boolean(key_name, required: false, title: nil, description: nil, array: false, examples: [])
      add_required(key_name, required)
      add_property("boolean", key_name, title: title, description: description, examples: examples, enum: nil)
      add_array(key_name, array)
    end

    def object(key_name = nil, required: false, array: false, schema: nil, &block)
      add_required(key_name, required)

      if schema
        nested_object = schema
      else
        nested_object = Base.new
        nested_object.instance_eval(&block)
      end

      if key_name
        @properties[key_name] = nested_object.schema
        add_array(key_name, array)
      else
        @properties = nested_object.schema
      end
    end

    def schema
      {
        type: "object",
        required: (required_key_names unless required_key_names.empty?),
        properties: properties,
      }.compact
    end

    private

    attr_reader :properties, :required_key_names

    def add_required(key_name, required)
      return unless required

      @required_key_names << key_name
    end

    def add_property(type, key_name, title:, description:, examples:, enum:)
      enum = [enum].flatten
      examples = [examples].flatten

      @properties[key_name] = { type: type }
      @properties[key_name][:description] = description if description
      @properties[key_name][:title] = title if title
      @properties[key_name][:examples] = examples if examples
      @properties[key_name][:enum] = enum if enum
    end

    def add_array(key_name, array)
      return unless array

      array_obj = @properties[key_name]
      @properties[key_name] = {
        type: "array",
        items: array_obj,
      }
    end
  end
end
