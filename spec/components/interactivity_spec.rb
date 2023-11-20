require "rails_helper"
require_relative "classes"

RSpec.describe "Component actions", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "triggers a component action" do
    visit "/simple_action"
    click_button "Trigger action"
    expect(page).to have_content("Action triggered")
  end

  it "triggers a component action with a parameter"

  it "triggers a component action with a parameter taken from an HTML element"

  it "triggers a component action with parameters taken from a form"

  it "ignores the response from a component action"

  it "removes the element after a component action"

  it "redirects after a component action"
end
