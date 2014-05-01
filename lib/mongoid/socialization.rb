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
    autoload :LikeModel,      "mongoid/socialization/likes/like_model"
    autoload :FollowModel,    "mongoid/socialization/follows/follow_model"

    def self.like_model
      if @like_model
        @like_model
      else
        LikeModel
      end
    end

    def self.like_model=(klass)
      @like_model = klass
    end

    def self.follow_model
      if @follow_model
        @follow_model
      else
        FollowModel
      end
    end

    def self.follow_model=(klass)
      @follow_model = klass
    end
  end
end

Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)