require "rails_helper"

RSpec.describe "Component properties" do
  it "defines properties" do
    component_class = Class.new do
      include Stimul8::Component
      property :name
    end
    component = component_class.new(name: "Alice")
    expect(component.name).to eq("Alice")
  end

  it "enforces property types" do
    component_class = Class.new do
      include Stimul8::Component
      property :age, type: :integer
    end
    expect { component_class.new(age: "Thirty-Seven") }.to raise_exception(ArgumentError)
  end

  it "creates ? accessors for boolean properties" do
    component_class = Class.new do
      include Stimul8::Component
      property :important, type: :boolean
    end

    important_component = component_class.new(important: true)
    expect(important_component.important).to eq true
    expect(important_component.important?).to eq true

    unimportant_component = component_class.new(important: false)
    expect(unimportant_component.important).to eq nil
    expect(unimportant_component.important?).to eq false
  end

  it "encodes boolean types" do
    component_class = Class.new do
      include Stimul8::Component
      property :important, type: :boolean
    end
    ActiveRecord::Type::Boolean::FALSE_VALUES.each do |value|
      expect(component_class.new(important: value)).to_not be_important
    end
    [true, 1, "1", "t", "T", "true", "TRUE", "on", "ON", "YES", "Hell Yes!!!"].each do |value|
      expect(component_class.new(important: value)).to be_important
    end
  end

  it "disallows nils" do
    component_class = Class.new do
      include Stimul8::Component
      property :name, nil: false
    end
    expect { component_class.new(name: nil) }.to raise_exception(ArgumentError)
  end

  it "has default values" do
    component_class = Class.new do
      include Stimul8::Component
      property :selected, type: :boolean, default: true
    end
    expect(component_class.new.selected).to eq true
  end

  it "validates property values" do
    component_class = Class.new do
      include Stimul8::Component
      property :day_of_week do |value|
        %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].include?(value)
      end
    end
    expect { component_class.new(day_of_week: "January") }.to raise_exception(ArgumentError)
  end
end
