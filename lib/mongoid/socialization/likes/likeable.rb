module Mongoid
  module Likeable
    extend ActiveSupport::Concern

    included do
      field :likes_count, type: Hash, default: {}

      after_destroy { Socialization.like_model.remove_likers(self) }
    end

    def likes_count(klass=nil)
      if klass.nil?
        read_attribute(:likes_count).values.sum
      else
        read_attribute(:likes_count)[klass.name]
      end
    end

    def update_likes_count!(klass, count)
      hash = read_attribute(:likes_count)
      hash[klass.name] = count

      update_attribute :likes_count, hash
    end

    def liked_by?(liker)
      Socialization::LikeModel.liked?(liker, self)
    end

    def likers(klass)
      Socialization::LikeModel.likers(self, klass)
    end

    def liker_ids(klass)
      Socialization::LikeModel.likers(self, klass).pluck("_id")
    end

  end
end