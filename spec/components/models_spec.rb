require "rails_helper"
require_relative "classes"

RSpec.describe "Component models" do
  it "defines models using an ID" do
    component_class = Class.new do
      include Stimul8::Component
      model :person
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(person: bob)
    expect(component.person_id).to eq bob.id
  end

  it "accepts a nil model" do
    component_class = Class.new do
      include Stimul8::Component
      model :person
    end
    component = component_class.new(person: nil)
    expect(component.person_id).to be_nil
  end

  it "loads the model on demand" do
    component_class = Class.new do
      include Stimul8::Component
      model :person
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(person: bob)
    expect(component.person).to eq bob
  end

  it "allows a custom class name" do
    component_class = Class.new do
      include Stimul8::Component
      model :owner, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    component = component_class.new(owner: bob)
    expect(component.owner).to eq bob
  end

  it "recreates a component from a component ID" do
    component_class = Class.new do
      include Stimul8::Component
      model :father, class_name: "Person"
      model :mother, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    alice = Person.new(2, "Alice")
    component_id = component_class.new(father: bob, mother: alice).component_id

    component = component_class.recreate(component_id)
    expect(component.father).to eq bob
    expect(component.mother).to eq alice
  end
end
