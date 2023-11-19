require "stimul8/version"
require "stimul8/engine"
require "stimul8/storage"
require "markaby/lib/markaby"
require "stimul8/component"

module Stimul8
end

ActiveSupport.on_load(:action_controller_base) do
  helper Stimul8::ApplicationHelper
end
