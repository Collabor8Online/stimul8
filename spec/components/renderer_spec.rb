require "rails_helper"
require_relative "classes"

RSpec.describe "Component rendering" do
  it "renders based on the value of the supplied context" do
    component = ConditionalRenderComponent.new context: "Alice"
    expect(component.to_html).to include("Hello")
    component = ConditionalRenderComponent.new context: nil
    expect(component.to_html).to be_blank
  end

  it "renders a container div" do
    component = NameBadgeComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class}[data-stimul8-class-name-value=\"NameBadgeComponent\"]")).to be_present
  end

  it "renders an alternative container tag" do
    component = SidebarComponent.new
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("aside##{component.component_id}.#{component.component_class}")).to be_present
  end

  it "renders contents passed as a block" do
    component = ContentComponent.new do
      "<p>Hello</p>"
    end
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class} p").text).to eq "Hello"
  end

  it "renders properties" do
    component = NameBadgeComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div.badge p").text).to eq("Hello Alice")
  end

  it "renders a container div with additional classes" do
    component = NameBadgeComponent.new(name: "Alice", attributes: {class: "selected"})
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class}.selected")).to be_present
  end

  it "renders a container div with additional attributes" do
    component = NameBadgeComponent.new(name: "Alice", attributes: {style: "display: none;"})
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class}[style=\"display: none;\"]")).to be_present
  end

  it "includes the stimul8 stimulus controller" do
    component = NameBadgeComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class}[data-stimul8-class-name-value=\"NameBadgeComponent\"][data-controller=\"stimul8\"]")).to be_present
  end

  it "allows extra stimulus controllers to be connected" do
    component = NameBadgeComponent.new(name: "Alice", attributes: {data: {controller: "my-controller"}})
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class}[data-stimul8-class-name-value=\"NameBadgeComponent\"][data-controller=\"stimul8 my-controller\"]")).to be_present
  end

  it "renders other components inside a component" do
    component = EmbeddedComponent.new(name: "Alice")
    doc = Nokogiri::HTML component.to_html
    expect(doc.css("div##{component.component_id}.#{component.component_class} div.badge p").text).to eq "Hello Alice"
  end

  it "generates a stylesheet" do
    component = SidebarComponent.new
    parser = CssParser::Parser.new
    parser.load_string! component.stylesheet
    expect(parser.find_by_selector(".sidebar-component ul.menu").first).to eq "background-color: #fff; font-size: 18px;"
    expect(parser.find_by_selector(".sidebar-component ul.menu li").first).to eq "font-size: 14px;"
  end
end
