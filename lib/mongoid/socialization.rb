require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid/socialization/document_additions"

module Mongoid
  autoload :Likeable,             "mongoid/socialization/likes/likeable"
  autoload :Liker,                "mongoid/socialization/likes/liker"

  autoload :Followable,           "mongoid/socialization/follows/followable"
  autoload :Follower,             "mongoid/socialization/follows/follower"

  autoload :WishListable,         "mongoid/socialization/wish_lists/wish_listable"
  autoload :WishLister,           "mongoid/socialization/wish_lists/wish_lister"

  autoload :Conversationable,     "mongoid/socialization/conversations/conversationable"

  module Socialization
    autoload :ArgumentError,      "mongoid/socialization/argument_error"
    autoload :LikeModel,          "mongoid/socialization/likes/like_model"
    autoload :FollowModel,        "mongoid/socialization/follows/follow_model"
    autoload :WishListModel,      "mongoid/socialization/wish_lists/wish_list_model"
    autoload :ConversationModel,  "mongoid/socialization/conversations/conversation_model"
    autoload :MessageModel,       "mongoid/socialization/conversations/message_model"

    def self.like_model
      @like_model.presence || LikeModel
    end

    def self.like_model=(klass)
      @like_model = klass
    end

    def self.follow_model
      @follow_model.presence || FollowModel
    end

    def self.follow_model=(klass)
      @follow_model = klass
    end

    def self.wish_list_model
      @wish_list_model.presence || WishListModel
    end

    def self.wish_list_model=(klass)
      @wish_list_model = klass
    end

    def self.conversation_model
      ConversationModel
    end

    def self.message_model
      MessageModel
    end

    def self.conversationer_klass_name=(klass_name)
      @conversationer_klass_name = klass_name
    end

    def self.conversationer_model
      @conversationer_klass_name.constantize
    end

    def self.boolean_klass
      defined?(Mongoid::Boolean) ? Mongoid::Boolean : Boolean
    end
  end
end

Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)