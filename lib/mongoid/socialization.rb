require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid/socialization/extensions/document"

module Mongoid
  autoload :Likeable,         "mongoid/socialization/victims/likeable"
  autoload :Liker,            "mongoid/socialization/actors/liker"

  module Socialization
    autoload :ArgumentError,  "mongoid/socialization/argument_error"
  end
end