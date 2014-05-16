module Mongoid
  module Socialization
    module Likeable
      extend ActiveSupport::Concern

      included do
        attr_accessor           :liker, :unliker
        field                   :likes_count, type: Hash, default: {}

        after_destroy           { like_klass.remove_likers(self) }
        define_model_callbacks  :like, :unlike
        observable              :like, :unlike
      end

      def likes_count(klass=nil)
        if klass.nil?
          read_attribute(:likes_count).values.sum
        else
          read_attribute(:likes_count)[klass.name]
        end
      end

      def update_likes_count!(klass, count)
        hash = read_attribute(:likes_count)
        hash[klass.name] = count

        set(likes_count: hash)
      end

      def liked_by?(liker)
        like_klass.liked?(liker, self)
      end

      def likers(klass)
        like_klass.likers(self, klass)
      end

      def liker_ids(klass)
        likers(klass).pluck("_id")
      end
    end
  end
end