require 'mongoid/socialization/version'

require 'active_support/concern'
require 'mongoid-observers'       unless Mongoid::VERSION.start_with?('3.1')

module Mongoid
  module Socialization
    autoload :DocumentAdditions,  'mongoid/socialization/document_additions'
    autoload :Error,              'mongoid/socialization/error'

    autoload :Like,               'mongoid/socialization/likes/like'
    autoload :LikeModel,          'mongoid/socialization/likes/like_model'
    autoload :Likeable,           'mongoid/socialization/likes/likeable'
    autoload :Liker,              'mongoid/socialization/likes/liker'

    autoload :Follow,             'mongoid/socialization/follows/follow'
    autoload :FollowModel,        'mongoid/socialization/follows/follow_model'
    autoload :Followable,         'mongoid/socialization/follows/followable'
    autoload :Follower,           'mongoid/socialization/follows/follower'

    autoload :WishList,           'mongoid/socialization/wish_lists/wish_list'
    autoload :WishListModel,      'mongoid/socialization/wish_lists/wish_list_model'
    autoload :WishListable,       'mongoid/socialization/wish_lists/wish_listable'
    autoload :WishLister,         'mongoid/socialization/wish_lists/wish_lister'

    autoload :Mention,            'mongoid/socialization/mentions/mention'
    autoload :MentionModel,       'mongoid/socialization/mentions/mention_model'
    autoload :Mentionable,        'mongoid/socialization/mentions/mentionable'
    autoload :Mentioner,          'mongoid/socialization/mentions/mentioner'

    autoload :Conversation,       'mongoid/socialization/conversations/conversation'
    autoload :ConversationModel,  'mongoid/socialization/conversations/conversation_model'
    autoload :Message,            'mongoid/socialization/conversations/message'
    autoload :MessageModel,       'mongoid/socialization/conversations/message_model'
    autoload :Conversationable,   'mongoid/socialization/conversations/conversationable'

    autoload :Notification,       'mongoid/socialization/notifications/notification'
    autoload :NotificationModel,  'mongoid/socialization/notifications/notification_model'
    autoload :Notifier,           'mongoid/socialization/notifications/notifier'
    autoload :Notifiable,         'mongoid/socialization/notifications/notifiable'
  end
end

require 'mongoid/socialization/config'
Mongoid::Document.send(:include, Mongoid::Socialization::DocumentAdditions)