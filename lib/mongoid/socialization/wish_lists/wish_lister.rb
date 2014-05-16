module Mongoid
  module Socialization
    module WishLister
      extend ActiveSupport::Concern

      included do
        after_destroy { wish_list_klass.remove_wish_listables(self) }
      end

      def wish_list!(wish_listable)
        wish_list_klass.validate_wish_listable!(wish_listable)

        wish_listable.run_callbacks :wish_list do
          wish_list_klass.wish_list!(self, wish_listable)
        end
      end

      def unwish_list!(wish_listable)
        wish_list_klass.validate_wish_listable!(wish_listable)

        wish_listable.run_callbacks :unwish_list do
          wish_list_klass.unwish_list!(self, wish_listable)
        end
      end

      def toggle_wish_list!(wish_listable)
        wish_list_klass.toggle_wish_list!(self, wish_listable)
      end

      def wish_listed?(wish_listable)
        wish_list_klass.wish_listed?(self, wish_listable)
      end

      def wish_listables(klass)
        wish_list_klass.wish_listables(self, klass)
      end

      def wish_listable_ids(klass)
        wish_listables.pluck("_id")
      end
    end
  end
end