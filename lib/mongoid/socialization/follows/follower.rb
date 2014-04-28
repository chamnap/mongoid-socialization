module Mongoid
  module Follower
    extend ActiveSupport::Concern

    included do
      field :followings_count, type: Integer,  default: 0
      field :following_ids,    type: Array,    default: []
    end

    def follow!(followable)
      Socialization::Follows.follow!(self, followable)
    end

    def unfollow!(followable)
      Socialization::Follows.unfollow!(self, followable)
    end

    def toggle_follow!(followable)
      Socialization::Follows.toggle_follow!(self, followable)
    end

    def followed?(followable)
      Socialization::Follows.followed?(self, followable)
    end

    def followables(klass)
      Socialization::Follows.followables(self, klass)
    end
  end
end