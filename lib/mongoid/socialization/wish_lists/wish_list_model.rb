module Mongoid
  module Socialization
    module WishListModel
      extend ActiveSupport::Concern

      included do

        # Indexes
        index({ wish_listable_id: 1, wish_listable_type: 1 }, { background: true })
        index({ wish_lister_id: 1, wish_lister_type: 1 }, { background: true })

        # Relations
        belongs_to  :wish_lister,         polymorphic: true
        belongs_to  :wish_listable,       polymorphic: true

        # Scopes
        scope :wish_listed_by, ->(wish_lister) {
          where(wish_lister_type: wish_lister.class.name, wish_lister_id: wish_lister.id)
        }

        scope :wish_listing,   ->(wish_listable) {
          where(wish_listable_type: wish_listable.class.name, wish_listable_id: wish_listable.id)
        }
      end

      module ClassMethods
        def wish_list!(wish_lister, wish_listable)
          return false if wish_listed?(wish_lister, wish_listable)

          create!(wish_lister: wish_lister, wish_listable: wish_listable)
          wish_listable.update_wish_listers_count!(wish_lister.class, wish_listers(wish_listable, wish_lister.class).size)
          wish_lister.update_wish_listables_count!(wish_listable.class, wish_listables(wish_lister, wish_listable.class).size)
          true
        end

        def unwish_list!(wish_lister, wish_listable)
          return false unless wish_listed?(wish_lister, wish_listable)

          wish_list_for(wish_lister, wish_listable).delete_all
          wish_listable.update_wish_listers_count!(wish_lister.class, wish_listers(wish_listable, wish_lister.class).size)
          wish_lister.update_wish_listables_count!(wish_listable.class, wish_listables(wish_lister, wish_listable.class).size)
          true
        end

        def toggle_wish_list!(wish_lister, wish_listable)
          if wish_listed?(wish_lister, wish_listable)
            unwish_list!(wish_lister, wish_listable)
          else
            wish_list!(wish_lister, wish_listable)
          end
        end

        def wish_listed?(wish_lister, wish_listable)
          validate_wish_lister!(wish_lister)
          validate_wish_listable!(wish_listable)

          wish_list_for(wish_lister, wish_listable).present?
        end

        def wish_listables(wish_lister, klass)
          validate_wish_lister!(wish_lister)
          validate_wish_listable!(klass)

          wish_listable_ids = only(:wish_listable_id).
            where(wish_listable_type: klass.name).
            where(wish_lister_type: wish_lister.class.name).
            where(wish_lister_id: wish_lister.id).
            collect(&:wish_listable_id)
          klass.where(:_id.in => wish_listable_ids)
        end

        def wish_listers(wish_listable, klass)
          validate_wish_lister!(klass)
          validate_wish_listable!(wish_listable)

          wish_lister_ids = only(:wish_lister_id).
            where(wish_lister_type: klass.name).
            where(wish_listable_type: wish_listable.class.name).
            where(wish_listable_id: wish_listable.id).
            collect(&:wish_lister_id)
          klass.where(:_id.in => wish_lister_ids)
        end

        def remove_wish_listables(wish_lister)
          where(wish_lister_type: wish_lister.class.name, wish_lister_id: wish_lister.id).delete_all
        end

        def remove_wish_listers(wish_listable)
          where(wish_listable_type: wish_listable.class.name, wish_listable_id: wish_listable.id).delete_all
        end

        def wish_list_for(wish_lister, wish_listable)
          wish_listed_by(wish_lister).wish_listing(wish_listable)
        end

        def validate_wish_lister!(wish_lister)
          raise Socialization::Error.new(wish_lister, "is not a wish_lister")        unless wish_lister.respond_to?(:wish_lister?) && wish_lister.wish_lister?
        end

        def validate_wish_listable!(wish_listable)
          raise Socialization::Error.new(wish_listable, "is not a wish_listable")    unless wish_listable.respond_to?(:wish_listable?) && wish_listable.wish_listable?
        end
      end
    end
  end
end