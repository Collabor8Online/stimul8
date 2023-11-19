module Stimul8
  module Component
    extend ActiveSupport::Concern
    require "stimul8/component/storage"
    require "stimul8/component/core"
    require "stimul8/component/models"

    included do
      include Stimul8::Component::Storage
      include Stimul8::Component::Core
      include Stimul8::Component::Models
    end
  end
end
