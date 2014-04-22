module Mongoid
  module Likeable
    extend ActiveSupport::Concern

    included do
      field :likes_count, type: Integer,  default: 0
      field :liker_ids,   type: Array,    default: []
    end

    def liked_by?(liker)
      Socialization::Likes.liked?(liker, self)
    end

    def likers
      Socialization::Likes.likers(self)
    end

  end
end