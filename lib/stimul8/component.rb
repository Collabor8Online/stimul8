module Stimul8
  module Component
    extend ActiveSupport::Concern
    require "stimul8/component/storage"
    require "stimul8/component/properties"
    require "stimul8/component/models"
    require "stimul8/component/renderer"

    included do
      include Stimul8::Component::Storage
      include Stimul8::Component::Properties
      include Stimul8::Component::Models
      include Stimul8::Component::Renderer
    end
  end
end
