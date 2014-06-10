module Mongoid
  module Socialization
    module WishLister
      extend ActiveSupport::Concern

      included do
        field           :wish_listables_count, type: Hash,  default: {}

        after_destroy   { wish_list_klass.remove_wish_listables(self) }
      end

      def wish_listables_count(klass=nil)
        if klass.nil?
          read_attribute(:wish_listables_count).values.sum
        else
          read_attribute(:wish_listables_count).fetch(klass.name, 0)
        end
      end

      def update_wish_listables_count!(klass, count)
        hash = read_attribute(:wish_listables_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:wish_listables_count, hash)
        else
          set(wish_listables_count: hash)
        end
      end

      def wish_list!(wish_listable)
        wish_list_klass.validate_wish_listable!(wish_listable)

        wish_listable.run_callbacks :wish_list do
          wish_list_klass.wish_list!(self, wish_listable)
          wish_listable.wish_lister = self
        end
      end

      def wish_list(wish_listable)
        wish_list!(wish_listable)
      rescue
        false
      else
        true
      end

      def unwish_list!(wish_listable)
        wish_list_klass.validate_wish_listable!(wish_listable)

        wish_listable.run_callbacks :unwish_list do
          wish_list_klass.unwish_list!(self, wish_listable)
          wish_listable.unwish_lister = self
        end
      end

      def unwish_list(wish_listable)
        unwish_list!(wish_listable)
      rescue
        false
      else
        true
      end

      def toggle_wish_list!(wish_listable)
        wish_list_klass.toggle_wish_list!(self, wish_listable)
      end

      def toggle_wish_list(wish_listable)
        toggle_wish_list!(wish_listable)
      rescue
        false
      else
        true
      end

      def wish_listed?(wish_listable)
        wish_list_klass.wish_listed?(self, wish_listable)
      rescue
        false
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