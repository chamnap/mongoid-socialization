module Mongoid
  module Socialization
    class Like
      include Mongoid::Document
      include Mongoid::Timestamps
      include LikeModel

      store_in    collection: "mongoid_socialization_likes"
    end
  end
end