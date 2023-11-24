module Stimul8
  module Component
    module Actions
      extend ActiveSupport::Concern

      def calls method_name, parameters = {}
        validate_parameters! method_name, parameters
        data = {action: "stimul8--component#callMethod", stimul8__component_method_name_param: method_name}
        if (events = parameters.delete(:on))
          data[:action] = Array.wrap(events).map { |e| "#{e}->stimul8--component#callMethod" }.join(" ")
        end

        parameters.each do |name, value|
          data[:"stimul8__component_#{name.to_s.underscore}_param"] = value
        end
        {data: data}
      end

      class_methods do
        def authorise method_name, &authorisation_rule
          authorisation_rules[method_name.to_sym] = authorisation_rule
        end
        alias_method :authorize, :authorise

        def authorisation_rules
          @authorisation_rules ||= {}
        end
      end

      def call_method method_name, **parameters
        method_name = method_name.to_sym
        authorise! method_name
        method_parameters = parameters_for method_name
        parameters = parameters.transform_keys { |key| key.to_s.underscore.to_sym }
        send method_name.to_sym, **parameters.slice(*method_parameters)
      end

      def authorise! method_name
        rule = self.class.authorisation_rules[method_name.to_sym]
        raise AuthorisationError unless rule.nil? || instance_eval(&rule)
      end

      def parameters_for method_name
        method(method_name).parameters.map(&:last)
      end

      def mandatory_parameters_for method_name
        method(method_name).parameters.collect do |param|
          [:req, :keyreq].include?(param.first) ? param.last : nil
        end.compact
      end

      def validate_parameters! method_name, parameters = {}
        missing_parameters = mandatory_parameters_for(method_name) - parameters.keys
        raise Stimul8::MissingParameterError.new(missing_parameters.map(&:to_s).join(", ")) unless missing_parameters.empty?
      end
    end
  end
end
