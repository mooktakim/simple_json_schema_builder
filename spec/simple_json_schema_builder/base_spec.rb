# frozen_string_literal: true

class TestSchema < SimpleJsonSchemaBuilder::Base
  class TestSubSchema < SimpleJsonSchemaBuilder::Base
    object do
      string :test1
      integer :test2, required: true
    end
  end

  object do
    string :string1,
           required: true,
           title: "String1 Title",
           description: "String1 Description",
           array: false,
           examples: ["Test1 Example"],
           enum: nil

    string :string2,
           array: true

    string :string3,
           required: true,
           enum: ["Test3 A", "Test3 B"]

    string :string4,
           array: true,
           enum: ["Test4 A", "Test4 B"]

    integer :integer1,
            required: true,
            title: "Integer1 Title",
            description: "Integer1 Description",
            array: false,
            examples: [1, 2, 3],
            enum: nil

    integer :integer2,
            array: true

    integer :integer3,
            required: true,
            enum: [4, 5, 6]

    integer :integer4,
            array: true,
            enum: [7, 8, 9]

    number :number1,
           required: true,
           title: "Number1 Title",
           description: "Number1 Description",
           array: false,
           examples: [1, -2, 4],
           enum: nil

    number :number2,
           array: true

    number :number3,
           required: true,
           enum: [1, -1, 4, 1]

    number :number4,
           array: true,
           enum: [-1, -2, -3]

    boolean :boolean1,
            required: true,
            title: "Boolean1 Title",
            description: "Boolean1 Description",
            array: false,
            examples: [true, false]

    boolean :boolean2,
            array: true

    object :object1, required: true do
      string :obj_test1
      string :obj_test2, required: true
    end

    object :object2, array: true do
      string :obj_test1
      string :obj_test2, required: true
    end

    object :object3, required: true, schema: TestSubSchema
    object :object4, array: true, schema: TestSubSchema
  end
end

RSpec.describe SimpleJsonSchemaBuilder::Base do
  subject { TestSchema.schema }
  let(:properties) { subject[:properties] }

  it "correctly formats schema" do
    expect(subject[:type]).to eq("object")
    expect(subject[:required]).to eq(%i[string1 string3 integer1 integer3 number1 number3 boolean1 object1 object3])

    # String
    expect(properties[:string1][:type]).to eq("string")
    expect(properties[:string1][:title]).to eq("String1 Title")
    expect(properties[:string1][:description]).to eq("String1 Description")
    expect(properties[:string1][:examples]).to eq(["Test1 Example"])

    expect(properties[:string2][:type]).to eq("array")
    expect(properties[:string2][:items][:type]).to eq("string")

    expect(properties[:string3][:type]).to eq("string")
    expect(properties[:string3][:enum]).to eq(["Test3 A", "Test3 B"])

    expect(properties[:string4][:type]).to eq("array")
    expect(properties[:string4][:items][:type]).to eq("string")
    expect(properties[:string4][:items][:enum]).to eq(["Test4 A", "Test4 B"])

    # Integer
    expect(properties[:integer1][:type]).to eq("integer")
    expect(properties[:integer1][:title]).to eq("Integer1 Title")
    expect(properties[:integer1][:description]).to eq("Integer1 Description")
    expect(properties[:integer1][:examples]).to eq([1, 2, 3])

    expect(properties[:integer2][:type]).to eq("array")
    expect(properties[:integer2][:items][:type]).to eq("integer")

    expect(properties[:integer3][:type]).to eq("integer")
    expect(properties[:integer3][:enum]).to eq([4, 5, 6])

    expect(properties[:integer4][:type]).to eq("array")
    expect(properties[:integer4][:items][:type]).to eq("integer")
    expect(properties[:integer4][:items][:enum]).to eq([7, 8, 9])

    # Number
    expect(properties[:number1][:type]).to eq("number")
    expect(properties[:number1][:title]).to eq("Number1 Title")
    expect(properties[:number1][:description]).to eq("Number1 Description")
    expect(properties[:number1][:examples]).to eq([1, -2, 4])

    expect(properties[:number2][:type]).to eq("array")
    expect(properties[:number2][:items][:type]).to eq("number")

    expect(properties[:number3][:type]).to eq("number")
    expect(properties[:number3][:enum]).to eq([1, -1, 4, 1])

    expect(properties[:number4][:type]).to eq("array")
    expect(properties[:number4][:items][:type]).to eq("number")
    expect(properties[:number4][:items][:enum]).to eq([-1, -2, -3])

    # Boolean
    expect(properties[:boolean1][:type]).to eq("boolean")
    expect(properties[:boolean1][:title]).to eq("Boolean1 Title")
    expect(properties[:boolean1][:description]).to eq("Boolean1 Description")
    expect(properties[:boolean1][:examples]).to eq([true, false])

    expect(properties[:boolean2][:type]).to eq("array")
    expect(properties[:boolean2][:items][:type]).to eq("boolean")

    # Object
    expect(properties[:object1][:type]).to eq("object")
    expect(properties[:object1][:properties][:obj_test1][:type]).to eq("string")
    expect(properties[:object1][:properties][:obj_test2][:type]).to eq("string")
    expect(properties[:object1][:required]).to eq([:obj_test2])

    expect(properties[:object2][:type]).to eq("array")
    expect(properties[:object2][:items][:type]).to eq("object")
    expect(properties[:object2][:items][:properties][:obj_test1][:type]).to eq("string")
    expect(properties[:object2][:items][:properties][:obj_test2][:type]).to eq("string")
    expect(properties[:object2][:items][:required]).to eq([:obj_test2])

    expect(properties[:object3][:type]).to eq("object")
    expect(properties[:object3][:properties][:test1][:type]).to eq("string")
    expect(properties[:object3][:properties][:test2][:type]).to eq("integer")
    expect(properties[:object3][:required]).to eq([:test2])

    expect(properties[:object4][:type]).to eq("array")
    expect(properties[:object4][:items][:type]).to eq("object")
    expect(properties[:object4][:items][:properties][:test1][:type]).to eq("string")
    expect(properties[:object4][:items][:properties][:test2][:type]).to eq("integer")
    expect(properties[:object4][:items][:required]).to eq([:test2])
  end
end
