require "rails_helper"
require_relative "classes"

RSpec.describe "Component actions" do
  it "attaches an action handler" do
    component = DefaultActionComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id} button[data-action=\"stimul8#callAction\"][data-stimul8-action-param=\"do_something\"]")).to be_present
  end

  it "attaches an action handler with a parameter" do
    component = ActionParametersComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id} button[data-action=\"stimul8#callAction\"][data-stimul8-first-param=\"Parameter\"][data-stimul8-second-param=\"Another\"]")).to be_present
  end

  it "overrides the default event handler" do
    component = EventHandlerComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id} button[data-action=\"click->stimul8#callAction\"][data-stimul8-action-param=\"do_something\"]")).to be_present
  end

  it "attaches multiple event handlers" do
    component = MultipleEventHandlersComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id} button[data-action=\"click->stimul8#callAction change->stimul8#callAction\"][data-stimul8-action-param=\"do_something\"]")).to be_present
  end
end
