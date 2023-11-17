require "rails_helper"
require_relative "classes"

RSpec.describe "Component rendering" do
  it "renders properties" do
    component = NameBadgeComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div.badge p").text).to eq("Hello Alice")
  end

  it "renders a container div" do
    component = NameBadgeComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.css_class}")).to be_present
  end

  it "allows for an alternative container tag" do
    component = SidebarComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("aside##{component.component_id}.#{component.css_class}")).to be_present
  end
end
