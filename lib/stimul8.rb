# frozen_string_literal: true

module Stimul8
  class Error < StandardError; end

  class SubclassMustImplement < Error; end
  require_relative "stimul8/version"
  require_relative "stimul8/component"
end
