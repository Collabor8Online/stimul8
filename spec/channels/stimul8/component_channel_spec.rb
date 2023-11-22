require "rails_helper"
require_relative "../../components/classes"

RSpec.describe Stimul8::ComponentChannel, type: :channel do
  before do
    stub_connection context: :current_user
  end

  let(:component) { PersonFormComponent.new first_name: "Alice", last_name: "Aardvark" }

  it "successfully subscribes" do
    subscribe component_class: "PersonFormComponent", component_id: component.component_id
    expect(subscription).to be_confirmed
    expect(subscription.component).to eq component
  end

  context "performing actions" do
    it "calls a method on the component" do
      subscribe component_class: "PersonFormComponent", component_id: component.component_id

      perform :call_method, method_name: "update_person", first_name: "Bob", last_name: "Badger"

      expect(component.first_name).to eq "Bob"
      expect(component.last_name).to eq "Badger"
    end
  end
end
