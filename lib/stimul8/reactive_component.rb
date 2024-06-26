require_relative "component"
require "dry/types"

module Stimul8
  include Dry::Types()

  Observable = Interface(:subscribe)
  Observer = Interface(:publish)

  class ReactiveComponent < Component
    class << self
      def observe observable
        @observable = Observable[observable]
      end

      def publish *events, to:
        @observer = Observer[to]
        events.each do |event|
          @observer.register_event event
        end
      end

      attr_reader :observable
      attr_reader :observer
    end

    def initialize
      super
      start_observing
    end

    def notify_observers event, **params
      observer&.publish event, **params
    end

    def redraw
      notify_observers "redraw"
    end

    private

    def observable
      self.class.observable
    end

    def observer
      self.class.observer
    end

    def start_observing
      observable&.subscribe self
    end

    def stop_observing
      observable&.unsubscribe self
    end
  end
end
