require "mongoid/socialization/version"

require "active_support/concern"
require "mongoid-observers"

module Mongoid
  module Socialization
    autoload :DocumentAdditions,  "mongoid/socialization/document_additions"
    autoload :ArgumentError,      "mongoid/socialization/argument_error"

    autoload :Like,               "mongoid/socialization/likes/like"
    autoload :LikeModel,          "mongoid/socialization/likes/like_model"
    autoload :Likeable,           "mongoid/socialization/likes/likeable"
    autoload :Liker,              "mongoid/socialization/likes/liker"

    autoload :Follow,             "mongoid/socialization/follows/follow"
    autoload :FollowModel,        "mongoid/socialization/follows/follow_model"
    autoload :Followable,         "mongoid/socialization/follows/followable"
    autoload :Follower,           "mongoid/socialization/follows/follower"

    autoload :WishList,           "mongoid/socialization/wish_lists/wish_list"
    autoload :WishListModel,      "mongoid/socialization/wish_lists/wish_list_model"
    autoload :WishListable,       "mongoid/socialization/wish_lists/wish_listable"
    autoload :WishLister,         "mongoid/socialization/wish_lists/wish_lister"

    autoload :Mention,            "mongoid/socialization/mentions/mention"
    autoload :MentionModel,       "mongoid/socialization/mentions/mention_model"
    autoload :Mentionable,        "mongoid/socialization/mentions/mentionable"
    autoload :Mentioner,          "mongoid/socialization/mentions/mentioner"

    autoload :Conversation,       "mongoid/socialization/conversations/conversation"
    autoload :Message,            "mongoid/socialization/conversations/message"
    autoload :Conversationable,   "mongoid/socialization/conversations/conversationable"
  end
end

require "mongoid/socialization/config"
Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)