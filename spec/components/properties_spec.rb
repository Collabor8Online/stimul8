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
      property :age, type: Integer
    end
    expect { component_class.new(age: "Thirty-Seven") }.to raise_exception(ArgumentError)
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

  it "disallows nils" do
    component_class = Class.new do
      include Stimul8::Component
      property :name, nil: false
    end
    expect { component_class.new(name: nil) }.to raise_exception(ArgumentError)
  end
end
