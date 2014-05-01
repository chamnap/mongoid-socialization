module Mongoid
  module WishListable
    extend ActiveSupport::Concern

    included do
      field :wish_lists_count, type: Hash, default: {}

      after_destroy { Socialization.wish_list_model.remove_wish_listers(self) }
    end

    def wish_lists_count(klass=nil)
      if klass.nil?
        read_attribute(:wish_lists_count).values.sum
      else
        read_attribute(:wish_lists_count)[klass.name]
      end
    end

    def update_wish_lists_count!(klass, count)
      hash = read_attribute(:wish_lists_count)
      hash[klass.name] = count

      update_attribute :wish_lists_count, hash
    end

    def wish_listed_by?(wish_lister)
      Socialization::WishListModel.wish_listed?(wish_lister, self)
    end

    def wish_listers(klass)
      Socialization::WishListModel.wish_listers(self, klass)
    end

    def wish_lister_ids(klass)
      wish_listers(klass).pluck("_id")
    end

  end
end