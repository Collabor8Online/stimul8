require "rails_helper"
require_relative "../../components/classes"

RSpec.describe Stimul8::ComponentChannel, type: :channel do
  let(:component) { NameBadgeComponent.new name: "Alice" }

  it "successfully subscribes" do
    stub_connection context: "Alice"
    subscribe component_class: "NameBadgeComponent", component_id: component.component_id
    expect(subscription).to be_confirmed
    expect(subscription.component).to eq component
  end
end
