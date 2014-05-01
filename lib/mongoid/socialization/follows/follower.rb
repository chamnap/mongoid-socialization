module Mongoid
  module Follower
    extend ActiveSupport::Concern

    included do
      field :followings_count, type: Hash,  default: {}

      after_destroy { Mongoid::Socialization.follow_model.remove_followables(self) }
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
      Socialization::FollowModel.follow!(self, followable)
    end

    def unfollow!(followable)
      Socialization::FollowModel.unfollow!(self, followable)
    end

    def toggle_follow!(followable)
      Socialization::FollowModel.toggle_follow!(self, followable)
    end

    def followed?(followable)
      Socialization::FollowModel.followed?(self, followable)
    end

    def followables(klass)
      Socialization::FollowModel.followables(self, klass)
    end
  end
end