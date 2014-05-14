module Mongoid
  module Socialization

    def self.like_model
      LikeModel
    end

    def self.follow_model
      FollowModel
    end

    def self.wish_list_model
      WishListModel
    end

    def self.mention_model
      MentionModel
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