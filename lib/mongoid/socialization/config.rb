module Mongoid
  module Socialization

    class << self
      attr_accessor :conversationer_klass_name

      def like_klass_name=(klass_name)
        @like_klass_name = klass_name
      end

      def like_klass_name
        @like_klass_name.presence || "Mongoid::Socialization::Like"
      end

      def like_klass
        @like_klass ||= like_klass_name.constantize
      end

      def follow_klass_name=(klass_name)
        @follow_klass_name = klass_name
      end

      def follow_klass_name
        @follow_klass_name.presence || "Mongoid::Socialization::Follow"
      end

      def follow_klass
        @follow_klass ||= follow_klass_name.constantize
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

      def conversationer_klass
        @conversationer_klass ||= @conversationer_klass_name.constantize
      end

      def boolean_klass
        defined?(Mongoid::Boolean) ? Mongoid::Boolean : Boolean
      end
    end
  end
end