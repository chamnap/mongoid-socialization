module Mongoid
  module Socialization
    module Likeable
      extend ActiveSupport::Concern

      included do
        field :likes_count, type: Hash, default: {}

        after_destroy { Socialization.like_klass.remove_likers(self) }
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

        update_attribute :likes_count, hash
      end

      def liked_by?(liker)
        Socialization.like_klass.liked?(liker, self)
      end

      def likers(klass)
        Socialization.like_klass.likers(self, klass)
      end

      def liker_ids(klass)
        likers(klass).pluck("_id")
      end

    end
  end
end