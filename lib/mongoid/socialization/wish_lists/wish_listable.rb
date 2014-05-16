module Mongoid
  module Socialization
    module WishListable
      extend ActiveSupport::Concern

      included do
        field                   :wish_lists_count, type: Hash, default: {}

        after_destroy           { wish_list_klass.remove_wish_listers(self) }
        define_model_callbacks  :wish_list, :unwish_list
        observable              :wish_list, :unwish_list
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

        set wish_lists_count: hash
      end

      def wish_listed_by?(wish_lister)
        wish_list_klass.wish_listed?(wish_lister, self)
      end

      def wish_listers(klass)
        wish_list_klass.wish_listers(self, klass)
      end

      def wish_lister_ids(klass)
        wish_listers(klass).pluck("_id")
      end
    end
  end
end