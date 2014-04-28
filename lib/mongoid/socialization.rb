require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid/socialization/document_additions"

module Mongoid
  autoload :Likeable,         "mongoid/socialization/likes/likeable"
  autoload :Liker,            "mongoid/socialization/likes/liker"

  autoload :Followable,       "mongoid/socialization/follows/followable"
  autoload :Follower,         "mongoid/socialization/follows/follower"

  module Socialization
    autoload :ArgumentError,  "mongoid/socialization/argument_error"
    autoload :Likes,          "mongoid/socialization/likes/likes"
    autoload :Follows,        "mongoid/socialization/follows/follows"
  end
end

Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)