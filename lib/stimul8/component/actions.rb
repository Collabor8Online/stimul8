module Stimul8
  module Component
    module Actions
      extend ActiveSupport::Concern

      def action action_name, parameters = {}
        action = if (event = parameters.delete(:event))
          "#{event}->stimul8#callAction"
        elsif (events = parameters.delete(:events))
          Array.wrap(events).map { |e| "#{e}->stimul8#callAction" }.join(" ")
        else
          "stimul8#callAction"
        end
        data = {action: action, stimul8_action_param: action_name.to_s}
        parameters.each do |name, value|
          data[:"stimul8_#{name.to_s.underscore}_param"] = value
        end
        {data: data}
      end
    end
  end
end
