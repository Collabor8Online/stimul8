module Stimul8
  module Storage
    extend ActiveSupport::Concern
    require "stimul8/storage/in_memory"

    def key_for component_id, property_name
      "#{component_id}:#{property_name}".intern
    end
  end
end
