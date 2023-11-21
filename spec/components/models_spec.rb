require "rails_helper"
require_relative "classes"

RSpec.describe "Linking components to models" do
  it "finds its models using an ID" do
    component_class = Class.new do
      include Stimul8::Component
      represents :person
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(person: bob)
    expect(component.person_id).to eq bob.id
  end

  it "does not have to be linked to a model" do
    component_class = Class.new do
      include Stimul8::Component
      represents :person
    end
    component = component_class.new(person: nil)
    expect(component.person_id).to be_nil
  end

  it "loads the model on demand" do
    component_class = Class.new do
      include Stimul8::Component
      represents :person
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(person: bob)
    expect(component.person).to eq bob
  end

  it "allows an overridden class name" do
    component_class = Class.new do
      include Stimul8::Component
      represents :owner, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(owner: bob)
    expect(component.owner).to eq bob
  end

  it "locates the models when the component is recreated" do
    component_class = Class.new do
      include Stimul8::Component
      represents :father, class_name: "Person"
      represents :mother, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    alice = Person.new(2, "Alice")
    component_id = component_class.new(father: bob, mother: alice).component_id

    component = component_class.new(component_id: component_id)
    expect(component.father).to eq bob
    expect(component.mother).to eq alice
  end
end
