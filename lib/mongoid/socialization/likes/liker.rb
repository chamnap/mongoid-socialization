module Mongoid
  module Liker
    extend ActiveSupport::Concern

    included do
      field :likeable_klasses,   type: Array,    default: []
    end

    def like!(likeable)
      Socialization::Likes.like!(self, likeable)
    end

    def unlike!(likeable)
      Socialization::Likes.unlike!(self, likeable)
    end

    def toggle_like!(likeable)
      Socialization::Likes.toggle_like!(self, likeable)
    end

    def liked?(likeable)
      Socialization::Likes.liked?(self, likeable)
    end

    def likeables(klass)
      Socialization::Likes.likeables(self, klass)
    end
  end
end