require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid/socialization/document_additions"

module Mongoid
  autoload :Likeable,         "mongoid/socialization/likes/likeable"
  autoload :Liker,            "mongoid/socialization/likes/liker"

  autoload :Followable,       "mongoid/socialization/follows/followable"
  autoload :Follower,         "mongoid/socialization/follows/follower"

  autoload :WishListable,     "mongoid/socialization/wish_lists/wish_listable"
  autoload :WishLister,       "mongoid/socialization/wish_lists/wish_lister"

  module Socialization
    autoload :ArgumentError,  "mongoid/socialization/argument_error"
    autoload :LikeModel,      "mongoid/socialization/likes/like_model"
    autoload :FollowModel,    "mongoid/socialization/follows/follow_model"
    autoload :WishListModel,  "mongoid/socialization/wish_lists/wish_list_model"

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

    def self.wish_list_model
      if @wish_list_model
        @wish_list_model
      else
        WishListModel
      end
    end

    def self.wish_list_model=(klass)
      @wish_list_model = klass
    end
  end
end

Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)