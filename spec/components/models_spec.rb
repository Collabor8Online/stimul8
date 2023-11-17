require "rails_helper"

RSpec.describe "Component models" do
  Person = Struct.new(:id, :name) do # standard:disable Lint/ConstantDefinitionInBlock
    class << self
      def find id
        models[id] || raise(ActiveRecord::RecordNotFound)
      end

      def models
        @models ||= {}
      end
    end

    def initialize *args
      super(*args)
      self.class.models[id] = self
    end
  end

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

  it "generates a hash of model IDs" do
    component_class = Class.new do
      include Stimul8::Component
      model :father, class_name: "Person"
      model :mother, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    alice = Person.new(2, "Alice")
    component = component_class.new(father: bob, mother: alice)
    expect(component.model_ids[:father_id]).to eq bob.id
    expect(component.model_ids[:mother_id]).to eq alice.id
  end

  it "generates a Base 64 component ID from the supplied models" do
    component_class = Class.new do
      include Stimul8::Component
      model :father, class_name: "Person"
      model :mother, class_name: "Person"
    end
    bob = Person.new(1, "Bob")
    alice = Person.new(2, "Alice")
    component = component_class.new(father: bob, mother: alice)

    model_ids = {father_id: bob.id, mother_id: alice.id}
    json = model_ids.to_json
    encoded = Base64.urlsafe_encode64(json)

    expect(component.component_id).to eq encoded
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
