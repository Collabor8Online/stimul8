# = About lib/markaby.rb
#
# By requiring <tt>lib/markaby</tt>, you can load Markaby's dependency (the Builder library,)
# as well as the full set of Markaby classes.
#
# For a full list of features and instructions, see the README.
$:.unshift __dir__

# Markaby is a module containing all of the great Markaby classes that
# do such an excellent job.
#
# * Markaby::Builder: the class for actually calling the Ruby methods
#   which write the HTML.
# * Markaby::CSSProxy: a class which adds element classes and IDs to
#   elements when used within Markaby::Builder.
# * Markaby::MetAid: metaprogramming helper methods.
# * Markaby::Tags: lists the roles of various XHTML tags to help Builder
#   use these tags as they are intended.
module Markaby
  class InvalidXhtmlError < StandardError; end
end

require "markaby/version"
require "builder" unless defined?(Builder)
require "markaby/tagset"
require "markaby/builder"
require "markaby/cssproxy"
