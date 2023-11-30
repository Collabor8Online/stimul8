require "rails_helper"

RSpec.describe "Component storage" do
  context "in-memory storage" do
    it "stores and retrieves property values associated with the components ID" do
      component_class = Class.new do
        include Stimul8::Component
        represents :person
        property :selected, type: :boolean, default: false
      end
      bob = Person.new(1, "Bob")
      component = component_class.new(person: bob)
      component_id = component.component_id
      component.selected = true

      new_component = component_class.new(component_id: component_id)
      expect(new_component.selected).to eq true
    end
  end
end
