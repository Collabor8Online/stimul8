require "rails_helper"

RSpec.describe "Component rendering" do
  it "renders html" do
    component_class = Class.new do
      include Stimul8::Component

      template do
        div class: "container" do
          p "Hello World"
        end
      end
    end

    doc = Nokogiri::HTML(component_class.new.to_html)
    expect(doc.css("div.container p").text).to eq("Hello World")
  end

  it "renders properties" do
    component_class = Class.new do
      include Stimul8::Component
      property :name

      template do
        div class: "container" do
          p "Hello #{@name}"
        end
      end
    end

    doc = Nokogiri::HTML(component_class.new(name: "Alice").to_html)
    expect(doc.css("div.container p").text).to eq("Hello Alice")
  end
end
