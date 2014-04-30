module Mongoid
  module Liker
    extend ActiveSupport::Concern

    included do
      after_destroy { Mongoid::Socialization.like_model.remove_likeables(self) }
    end

    def like!(likeable)
      Socialization::LikeModel.like!(self, likeable)
    end

    def unlike!(likeable)
      Socialization::LikeModel.unlike!(self, likeable)
    end

    def toggle_like!(likeable)
      Socialization::LikeModel.toggle_like!(self, likeable)
    end

    def liked?(likeable)
      Socialization::LikeModel.liked?(self, likeable)
    end

    def likeables(klass)
      Socialization::LikeModel.likeables(self, klass)
    end
  end
end