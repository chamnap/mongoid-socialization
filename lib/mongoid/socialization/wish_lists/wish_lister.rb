module Mongoid
  module WishLister
    extend ActiveSupport::Concern

    included do
      after_destroy { Mongoid::Socialization.wish_list_model.remove_wish_listables(self) }
    end

    def wish_list!(wish_listable)
      Socialization::WishListModel.wish_list!(self, wish_listable)
    end

    def unwish_list!(wish_listable)
      Socialization::WishListModel.unwish_list!(self, wish_listable)
    end

    def toggle_wish_list!(wish_listable)
      Socialization::WishListModel.toggle_wish_list!(self, wish_listable)
    end

    def wish_listed?(wish_listable)
      Socialization::WishListModel.wish_listed?(self, wish_listable)
    end

    def wish_listables(klass)
      Socialization::WishListModel.wish_listables(self, klass)
    end

    def wish_listable_ids(klass)
      wish_listables.pluck("_id")
    end
  end
end