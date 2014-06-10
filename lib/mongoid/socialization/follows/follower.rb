module Mongoid
  module Socialization
    module Follower
      extend ActiveSupport::Concern

      included do
        field          :followings_count, type: Hash,  default: {}

        after_destroy  { follow_klass.remove_followables(self) }
      end

      def followings_count(klass=nil)
        if klass.nil?
          read_attribute(:followings_count).values.sum
        else
          read_attribute(:followings_count).fetch(klass.name, 0)
        end
      end

      def update_followings_count!(klass, count)
        hash = read_attribute(:followings_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:followings_count, hash)
        else
          set(followings_count: hash)
        end
      end

      def follow!(followable)
        follow_klass.validate_followable!(followable)

        followable.run_callbacks :follow do
          follow_klass.follow!(self, followable)
          followable.follower = self
        end
      end

      def follow(followable)
        follow!(followable)
      rescue
        false
      else
        true
      end

      def unfollow!(followable)
        follow_klass.validate_followable!(followable)

        followable.run_callbacks :unfollow do
          follow_klass.unfollow!(self, followable)
          followable.unfollower = self
        end
      end

      def unfollow(followable)
        unfollow!(followable)
      rescue
        false
      else
        true
      end

      def toggle_follow!(followable)
        follow_klass.toggle_follow!(self, followable)
      end

      def toggle_follow(followable)
        toggle_follow!(followable)
      rescue
        false
      else
        true
      end

      def followed?(followable)
        follow_klass.followed?(self, followable)
      rescue
        false
      end

      def followings(klass)
        follow_klass.followables(self, klass)
      end

      def following_ids(klass)
        followables(klass).pluck("_id")
      end
    end
  end
end