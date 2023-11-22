module Stimul8
  class ComponentChannel < ApplicationCable::Channel
    attr_reader :component

    def subscribed
      @component = Stimul8::Component.recreate params[:component_class], params[:component_id], context: context
    end

    def unsubscribed
      @component = nil
    end

    def call_method data
      data = data.symbolize_keys
      data.delete :action
      method_name = data.delete :method_name
      @component.call_method(method_name, **data)
    end
  end
end
