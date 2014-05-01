module Mongoid
  module Followable
    extend ActiveSupport::Concern

    included do
      field :followers_count, type: Hash,  default: {}

      after_destroy { Mongoid::Socialization.follow_model.remove_followers(self) }
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

      update_attribute :followers_count, hash
    end

    def followed_by?(follower)
      Socialization::FollowModel.followed?(follower, self)
    end

    def followers(klass)
      Socialization::FollowModel.followers(self, klass)
    end

    def follower_ids(klass)
      followers(klass).pluck("_id")
    end
  end
end