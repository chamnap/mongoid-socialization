module Mongoid
  module Socialization
    module Follows

      def self.follow!(follower, followable)
        return false if followed?(follower, followable)

        followable.push              follower_ids: follower.id
        followable.update_attribute  :followers_count, followable.liker_ids.size

        follower.push                following_ids: followable.id
        follower.update_attribute    :followings_count, follower.following_ids.size
      end

      def self.unfollow!(follower, followable)
        return false if followed?(follower, followable)

        followable.pull              follower_ids: follower.id
        followable.update_attribute  :followers_count, followable.liker_ids.size

        follower.pull                following_ids: followable.id
        follower.update_attribute    :followings_count, follower.following_ids.size
      end

      def self.toggle_follow!(follower, followable)
        if followed?(follower, followable)
          unfollow!(follower, followable)
        else
          follow!(follower, followable)
        end
      end

      def self.followed?(follower, followable)
        validate_follower!(follower)
        validate_followable!(followable)

        followable.follower_ids.include?(follower.id)
      end

      def self.followables(follower, klass)
        validate_follower!(follower)
        validate_followable!(klass)
      end

      def self.followers(followable, klass)
      end

      private

        def self.validate_follower!(follower)
          raise Socialization::ArgumentError, "#{follower} is not follower!"      unless follower.respond_to?(:follower?) && follower.follower?
        end

        def self.validate_followable!(followable)
          raise Socialization::ArgumentError, "#{followable} is not followable!"  unless followable.respond_to?(:followable?) && followable.followable?
        end
    end
  end
end