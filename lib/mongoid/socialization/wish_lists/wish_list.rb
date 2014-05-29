module Mongoid
  module Socialization
    class WishList
      include Mongoid::Document
      include Mongoid::Timestamps
      include WishListModel

      store_in    collection: "mongoid_socialization_wish_lists"
    end
  end
end