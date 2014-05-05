module Mongoid
  module Socialization
    class WishListModel
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in    collection: "mongoid_socialization_wish_lists"

      # Indexes
      index({ wish_listable_id: 1, wish_listable_type: 1 }, { background: true })
      index({ wish_lister_id: 1, wish_lister_type: 1 }, { background: true })

      # Fields
      field       :wish_lister_type,    type: String
      field       :wish_lister_id,      type: Integer
      field       :wish_listable_type,  type: String
      field       :wish_listable_id,    type: Integer

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

      def self.wish_list!(wish_lister, wish_listable)
        return false if wish_listed?(wish_lister, wish_listable)

        self.create!(wish_lister: wish_lister, wish_listable: wish_listable)
        wish_listable.update_wish_lists_count!(wish_lister.class, wish_listers(wish_listable, wish_lister.class).size)
        true
      end

      def self.unwish_list!(wish_lister, wish_listable)
        return false unless wish_listed?(wish_lister, wish_listable)

        wish_list_for(wish_lister, wish_listable).delete_all
        wish_listable.update_wish_lists_count!(wish_lister.class, wish_listers(wish_listable, wish_lister.class).size)
        true
      end

      def self.toggle_wish_list!(wish_lister, wish_listable)
        if wish_listed?(wish_lister, wish_listable)
          unwish_list!(wish_lister, wish_listable)
        else
          wish_list!(wish_lister, wish_listable)
        end
      end

      def self.wish_listed?(wish_lister, wish_listable)
        validate_wish_lister!(wish_lister)
        validate_wish_listable!(wish_listable)

        wish_list_for(wish_lister, wish_listable).present?
      end

      def self.wish_listables(wish_lister, klass)
        validate_wish_lister!(wish_lister)
        validate_wish_listable!(klass)

        wish_listable_ids = only(:wish_listable_id).
          where(wish_listable_type: klass.name).
          where(wish_lister_type: wish_lister.class.name).
          where(wish_lister_id: wish_lister.id).
          collect(&:wish_listable_id)
        klass.where(:_id.in => wish_listable_ids)
      end

      def self.wish_listers(wish_listable, klass)
        validate_wish_lister!(klass)
        validate_wish_listable!(wish_listable)

        wish_lister_ids = only(:wish_lister_id).
          where(wish_lister_type: klass.name).
          where(wish_listable_type: wish_listable.class.name).
          where(wish_listable_id: wish_listable.id).
          collect(&:wish_lister_id)
        klass.where(:_id.in => wish_lister_ids)
      end

      def self.remove_wish_listables(wish_lister)
        where(wish_lister_type: wish_lister.class.name, wish_lister_id: wish_lister.id).delete_all
      end

      def self.remove_wish_listers(wish_listable)
        where(wish_listable_type: wish_listable.class.name, wish_listable_id: wish_listable.id).delete_all
      end

      private

        def self.wish_list_for(wish_lister, wish_listable)
          wish_listed_by(wish_lister).wish_listing(wish_listable)
        end

        def self.validate_wish_lister!(wish_lister)
          raise Socialization::ArgumentError, "#{wish_lister} is not wish_lister!"        unless wish_lister.respond_to?(:wish_lister?) && wish_lister.wish_lister?
        end

        def self.validate_wish_listable!(wish_listable)
          raise Socialization::ArgumentError, "#{wish_listable} is not wish_listable!"    unless wish_listable.respond_to?(:wish_listable?) && wish_listable.wish_listable?
        end
    end
  end
end