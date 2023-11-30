require "rails_helper"
require_relative "../../components/ruby_classes"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "connects without a context" do
    connect
    expect(connection.context).to be_nil
  end

  it "connects in a context" do
    Stimul8::CableConnection.load_context_from do |request, cookies|
      Person.find cookies.signed[:person_id]
    end

    person = Person.new 123, "Alice"

    cookies.signed[:person_id] = person.id
    connect
    expect(connection.context).to eq(person)
  ensure
    Stimul8::CableConnection.clear_context_loader
  end
end
