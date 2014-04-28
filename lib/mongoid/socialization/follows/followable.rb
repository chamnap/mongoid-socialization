module Mongoid
  module Followable
    extend ActiveSupport::Concern

    included do
      field :followers_count, type: Integer,  default: 0
      field :follower_ids,    type: Array,    default: []
    end

    def followed_by?(follower)
      Socialization::Follows.followed?(follower, self)
    end

    def followers(klass)
      Socialization::Follows.followers(self, klass)
    end
  end
end