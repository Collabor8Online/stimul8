module Stimul8
  class ComponentChannel < ApplicationCable::Channel
    attr_reader :component

    def subscribed
      @component = Stimul8::Component.recreate params[:component_class], params[:component_id], context: context
    end

    def unsubscribed
      @component = nil
    end

    def action data = {}
      action = data.delete("action")
      @component.send(action.to_sym, **data.symbolize_keys)
    end
  end
end
