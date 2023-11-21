module Stimul8
  module CableConnection
    extend ActiveSupport::Concern

    included do
      identified_by :context
    end

    def connect
      self.context = load_context
    end

    class << self
      def load_context_from &block
        @load_context = block
      end

      def clear_context_loader
        @load_context = nil
      end
      attr_reader :load_context
    end

    private

    def load_context
      Stimul8::CableConnection.load_context&.call(request, cookies)
    end
  end
end
