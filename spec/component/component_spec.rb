require "spec_helper"
require "phlex/testing/nokogiri"
require_relative "../../lib/stimul8/component"

RSpec.describe Stimul8::Component do
  include Phlex::Testing::Nokogiri::DocumentHelper

  it "renders as a standard Phlex::HTML component" do
    greetings = Class.new(Stimul8::Component) do
      def initialize name: "World"
        @name = name
      end

      def template
        h1 do
          p { "Hello #{@name}" }
        end
      end
    end

    output = render greetings.new(name: "Alice")
    expect(output.css("h1 p").text).to eq "Hello Alice"
  end
end
