require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid-observers"

module Mongoid
  autoload :Likeable,             "mongoid/socialization/likes/likeable"
  autoload :Liker,                "mongoid/socialization/likes/liker"

  autoload :Followable,           "mongoid/socialization/follows/followable"
  autoload :Follower,             "mongoid/socialization/follows/follower"

  autoload :WishListable,         "mongoid/socialization/wish_lists/wish_listable"
  autoload :WishLister,           "mongoid/socialization/wish_lists/wish_lister"

  autoload :Mentionable,          "mongoid/socialization/mentions/mentionable"
  autoload :Mentioner,            "mongoid/socialization/mentions/mentioner"

  autoload :Conversationable,     "mongoid/socialization/conversations/conversationable"

  module Socialization
    autoload :DocumentAdditions,    "mongoid/socialization/document_additions"
    autoload :ArgumentError,      "mongoid/socialization/argument_error"
    autoload :LikeModel,          "mongoid/socialization/likes/like_model"
    autoload :FollowModel,        "mongoid/socialization/follows/follow_model"
    autoload :WishListModel,      "mongoid/socialization/wish_lists/wish_list_model"
    autoload :MentionModel,       "mongoid/socialization/mentions/mention_model"
    autoload :ConversationModel,  "mongoid/socialization/conversations/conversation_model"
    autoload :MessageModel,       "mongoid/socialization/conversations/message_model"
  end
end

require "mongoid/socialization/config"
Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)