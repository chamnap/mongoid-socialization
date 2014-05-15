module Mongoid
  module Socialization
    module Follower
      extend ActiveSupport::Concern

      included do
        field         :followings_count, type: Hash,  default: {}

        after_destroy { Mongoid::Socialization.follow_klass.remove_followables(self) }
      end

      def followings_count(klass=nil)
        if klass.nil?
          read_attribute(:followings_count).values.sum
        else
          read_attribute(:followings_count)[klass.name]
        end
      end

      def update_followings_count!(klass, count)
        hash = read_attribute(:followings_count)
        hash[klass.name] = count

        update_attribute :followings_count, hash
      end

      def follow!(followable)
        Socialization.follow_klass.follow!(self, followable)
      end

      def unfollow!(followable)
        Socialization.follow_klass.unfollow!(self, followable)
      end

      def toggle_follow!(followable)
        Socialization.follow_klass.toggle_follow!(self, followable)
      end

      def followed?(followable)
        Socialization.follow_klass.followed?(self, followable)
      end

      def followings(klass)
        Socialization.follow_klass.followables(self, klass)
      end

      def following_ids(klass)
        followables(klass).pluck("_id")
      end
    end
  end
end