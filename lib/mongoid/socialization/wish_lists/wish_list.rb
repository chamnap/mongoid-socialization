module Mongoid
  module Socialization
    class WishList
      include WishListModel

      store_in    collection: "mongoid_socialization_wish_lists"
    end
  end
end