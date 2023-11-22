module Stimul8
  class Error < StandardError
  end

  class AuthorisationError < Error
  end

  require "stimul8/version"
  require "stimul8/engine"
  require "stimul8/storage"
  require "markaby/lib/markaby"
  require "stimul8/component"
end

ActiveSupport.on_load(:action_controller_base) do
  helper Stimul8::ApplicationHelper
end
ActiveSupport.on_load(:action_cable_connection) do
  include Stimul8::CableConnection
end
