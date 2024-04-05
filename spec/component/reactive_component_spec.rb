require "spec_helper"
require "phlex/testing/nokogiri"
require "dry/events/publisher"
require_relative "../../lib/stimul8/reactive_component"

RSpec.describe Stimul8::ReactiveComponent do
  include Phlex::Testing::Nokogiri::DocumentHelper

  it "observes a stream of events" do
    publisher = Class.new do
      include Dry::Events::Publisher[:observes_a_stream_of_events]
      register_event "name.changed"
    end

    events = publisher.new

    greetings_component = Class.new(Stimul8::ReactiveComponent) do
      observe events
      attr_reader :name

      def initialize name: "World"
        super()
        @name = name
      end

      def template
        p { "Hello #{@name}" }
      end

      def on_name_changed event
        @name = event[:name]
      end
    end

    greetings = greetings_component.new name: "Alice"
    expect(greetings.name).to eq "Alice"

    events.publish "name.changed", name: "Bob"

    expect(greetings.name).to eq "Bob"
  end

  it "publishes changes to another observer" do
    publisher = Class.new do
      include Dry::Events::Publisher[:publishing_changes_to_another_observer]
    end

    events = publisher.new

    greetings_component = Class.new(Stimul8::ReactiveComponent) do
      publish "name.changed", to: events
      attr_reader :name

      def initialize name: "World"
        super()
        @name = name
      end

      def template
        p { "Hello #{@name}" }
      end

      def name= value
        @name = value
        notify_observers "name.changed", name: value
      end
    end

    greetings = greetings_component.new name: "Alice"

    @new_name = nil
    events.subscribe "name.changed" do |event|
      @new_name = event[:name]
    end

    greetings.name = "Bob"

    expect(@new_name).to eq "Bob"
  end

  it "notifies an observer that it requires redrawing" do
    publisher = Class.new do
      include Dry::Events::Publisher[:notifies_an_observer_that_it_requires_redrawing]
    end

    events = publisher.new

    greetings_component = Class.new(Stimul8::ReactiveComponent) do
      publish "redraw", to: events
      attr_reader :name

      def initialize name: "World"
        super()
        @name = name
      end

      def template
        p { "Hello #{@name}" }
      end
    end

    greetings = greetings_component.new name: "Alice"

    @redraw_triggered = nil
    events.subscribe "redraw" do |event|
      @redraw_triggered = true
    end

    greetings.redraw

    expect(@redraw_triggered).to eq true
  end
end
