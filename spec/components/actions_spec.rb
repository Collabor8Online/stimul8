require "rails_helper"
require_relative "classes"

RSpec.describe "Interactions" do
  let(:simple_action_class) do
    Class.new do
      include Stimul8::Component
      property :done, default: false, type: :boolean

      template do
        button calls(:do_something)
      end

      def do_something
        self.done = true
      end
    end
  end

  let(:authorised_action_class) do
    Class.new do
      include Stimul8::Component
      property :done, default: false, type: :boolean

      template do
        button calls(:do_something)
      end

      authorise :do_something do
        context == "Alice"
      end

      def do_something
        self.done = true
      end
    end
  end

  let(:action_parameter_class) do
    Class.new do
      include Stimul8::Component
      property :first_name
      property :last_name

      template do
        button calls(:update_name, first_name: "Bob", last_name: "Badger")
      end

      def update_name first_name:, last_name:
        self.first_name = first_name
        self.last_name = last_name
      end
    end
  end

  let(:missing_parameter_class) do
    Class.new do
      include Stimul8::Component
      property :first_name
      property :last_name

      template do
        button calls(:update_name, first_name: "Bob")
      end

      def update_name first_name:, last_name:
        self.first_name = first_name
        self.last_name = last_name
      end
    end
  end

  context "calling methods remotely" do
    it "calls the method" do
      component = simple_action_class.new
      expect(component).to_not be_done

      component.call_method :do_something
      expect(component).to be_done
    end

    it "raises an authorisation exception if the method is not authorised" do
      alices_component = authorised_action_class.new context: "Alice"
      alices_component.call_method :do_something
      expect(alices_component).to be_done

      bobs_component = authorised_action_class.new context: "Bob"
      expect { bobs_component.call_method :do_something }.to raise_error Stimul8::AuthorisationError
    end

    context "with parameters" do
      it "calls the method" do
        component = action_parameter_class.new first_name: "Alice", last_name: "Aadvark"
        component.call_method :update_name, first_name: "Bob", last_name: "Badger"
        expect(component.first_name).to eq "Bob"
        expect(component.last_name).to eq "Badger"
      end

      it "converts parameters from JSON format to ruby format" do
        component = action_parameter_class.new first_name: "Alice", last_name: "Aadvark"
        component.call_method :update_name, firstName: "Bob", lastName: "Badger"
        expect(component.first_name).to eq "Bob"
        expect(component.last_name).to eq "Badger"
      end

      it "removes extra parameters" do
        component = action_parameter_class.new first_name: "Alice", last_name: "Aadvark"
        component.call_method :update_name, firstName: "Bob", lastName: "Badger", someSpuriousExtra: "Parameter"
        expect(component.first_name).to eq "Bob"
        expect(component.last_name).to eq "Badger"
      end
    end
  end

  context "handling events to call methods remotely" do
    it "attaches an action handler" do
      component = simple_action_class.new
      doc = Nokogiri::HTML component.to_html
      expect(doc.css("div##{component.component_id} button[data-action=\"stimul8--component#callMethod\"][data-stimul8--component-method-name-param=\"do_something\"]")).to be_present
    end

    it "attaches an action handler with parameters" do
      component = action_parameter_class.new first_name: "Alice", last_name: "Aardvark"
      doc = Nokogiri::HTML component.to_html
      expect(doc.css("div##{component.component_id} button[data-action=\"stimul8--component#callMethod\"][data-stimul8--component-method-name-param=\"update_name\"][data-stimul8--component-first-name-param=\"Bob\"][data-stimul8--component-last-name-param=\"Badger\"]")).to be_present
    end

    it "raises an error if you omit mandatory parameters for the remote method call" do
      component = missing_parameter_class.new first_name: "Alice", last_name: "Aardvark"
      expect { component.to_html }.to raise_error(Stimul8::MissingParameterError)
    end

    it "attaches a custom event handler" do
      component_class = Class.new do
        include Stimul8::Component
        template do
          button calls(:do_something, on: "custom-component-event")
        end
        def do_something
        end
      end
      component = component_class.new
      doc = Nokogiri::HTML component.to_html
      expect(doc.css("div##{component.component_id} button[data-action=\"custom-component-event->stimul8--component#callMethod\"][data-stimul8--component-method-name-param=\"do_something\"]")).to be_present
    end

    it "attaches multiple event handlers" do
      component_class = Class.new do
        include Stimul8::Component
        template do
          button calls(:do_something, on: ["first-event", "second-event"])
        end
        def do_something
        end
      end
      component = component_class.new
      doc = Nokogiri::HTML component.to_html
      expect(doc.css("div##{component.component_id} button[data-action=\"first-event->stimul8--component#callMethod second-event->stimul8--component#callMethod\"][data-stimul8--component-method-name-param=\"do_something\"]")).to be_present
    end
  end
end
