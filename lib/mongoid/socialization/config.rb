module Mongoid
  module Socialization

    class << self

      def like_klass=(klass)
        @like_klass = klass
      end

      def like_klass
        @like_klass.presence || Like
      end

      def follow_klass=(klass)
        @follow_klass = klass
      end

      def follow_klass
        @follow_klass.presence || Follow
      end

      def wish_list_klass=(klass)
        @wish_list_klass = klass
      end

      def wish_list_klass
        @wish_list_klass.presence || WishList
      end

      def mention_klass=(klass)
        @mention_klass = klass
      end

      def mention_klass
        @mention_klass.presence || Mention
      end

      def conversation_klass
        Conversation
      end

      def message_klass
        Message
      end

      def conversationer_klass_name=(klass_name)
        @conversationer_klass_name = klass_name
      end

      def conversationer_klass
        @conversationer_klass_name.constantize
      end

      def boolean_klass
        defined?(Mongoid::Boolean) ? Mongoid::Boolean : Boolean
      end
    end
  end
end