class SimpleActionComponent
  include Stimul8::Component
  property :triggered, type: :boolean, default: false

  template do
    div class: "simple-action" do
      button action(:trigger_action) do
        "Trigger action"
      end
    end
  end
end
