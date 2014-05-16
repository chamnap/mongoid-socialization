module Mongoid
  module Socialization
    module Followable
      extend ActiveSupport::Concern

      included do
        field                   :followers_count, type: Hash,  default: {}

        after_destroy           { follow_klass.remove_followers(self) }
        define_model_callbacks  :follow, :unfollow
        observable              :follow, :unfollow
      end

      def followers_count(klass=nil)
        if klass.nil?
          read_attribute(:followers_count).values.sum
        else
          read_attribute(:followers_count)[klass.name]
        end
      end

      def update_followers_count!(klass, count)
        hash = read_attribute(:followers_count)
        hash[klass.name] = count

        set(followers_count: hash)
      end

      def followed_by?(follower)
        follow_klass.followed?(follower, self)
      end

      def followers(klass)
        follow_klass.followers(self, klass)
      end

      def follower_ids(klass)
        followers(klass).pluck("_id")
      end
    end
  end
end