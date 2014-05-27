module Mongoid
  module Socialization
    module WishListable
      extend ActiveSupport::Concern

      included do
        attr_accessor           :wish_lister, :unwish_lister
        field                   :wish_listers_count, type: Hash, default: {}

        after_destroy           { wish_list_klass.remove_wish_listers(self) }
        define_model_callbacks  :wish_list, :unwish_list
        observable              :wish_list, :unwish_list
      end

      def wish_listers_count(klass=nil)
        if klass.nil?
          read_attribute(:wish_listers_count).values.sum
        else
          read_attribute(:wish_listers_count)[klass.name]
        end
      end

      def update_wish_listers_count!(klass, count)
        hash = read_attribute(:wish_listers_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:wish_listers_count, hash)
        else
          set(wish_listers_count: hash)
        end
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