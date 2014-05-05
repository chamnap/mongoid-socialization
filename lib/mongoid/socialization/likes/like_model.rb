module Mongoid
  module Socialization
    class LikeModel
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in    collection: "mongoid_socialization_likes"

      # Indexes
      index({ likeable_id: 1, likeable_type: 1 }, { background: true })
      index({ liker_id: 1, liker_type: 1 }, { background: true })

      # Fields
      field       :liker_type,    type: String
      field       :liker_id,      type: Integer
      field       :likeable_type, type: String
      field       :likeable_id,   type: Integer

      # Relations
      belongs_to  :liker,         polymorphic: true
      belongs_to  :likeable,      polymorphic: true

      # Scopes
      scope :liked_by, ->(liker) {
        where(liker_type: liker.class.name, liker_id: liker.id)
      }

      scope :liking,   ->(likeable) {
        where(likeable_type: likeable.class.name, likeable_id: likeable.id)
      }

      def self.like!(liker, likeable)
        return false if liked?(liker, likeable)

        self.create!(liker: liker, likeable: likeable)
        likeable.update_likes_count!(liker.class, likers(likeable, liker.class).size)
        true
      end

      def self.unlike!(liker, likeable)
        return false unless liked?(liker, likeable)

        like_for(liker, likeable).delete_all
        likeable.update_likes_count!(liker.class, likers(likeable, liker.class).size)
        true
      end

      def self.toggle_like!(liker, likeable)
        if liked?(liker, likeable)
          unlike!(liker, likeable)
        else
          like!(liker, likeable)
        end
      end

      def self.liked?(liker, likeable)
        validate_liker!(liker)
        validate_likeable!(likeable)

        like_for(liker, likeable).present?
      end

      def self.likeables(liker, klass)
        validate_liker!(liker)
        validate_likeable!(klass)

        likeable_ids = only(:likeable_id).
          where(likeable_type: klass.name).
          where(liker_type: liker.class.name).
          where(liker_id: liker.id).
          collect(&:likeable_id)
        klass.where(:_id.in => likeable_ids)
      end

      def self.likers(likeable, klass)
        validate_liker!(klass)
        validate_likeable!(likeable)

        liker_ids = only(:liker_id).
          where(liker_type: klass.name).
          where(likeable_type: likeable.class.name).
          where(likeable_id: likeable.id).
          collect(&:liker_id)
        klass.where(:_id.in => liker_ids)
      end

      def self.remove_likeables(liker)
        where(liker_type: liker.class.name, liker_id: liker.id).delete_all
      end

      def self.remove_likers(likeable)
        where(likeable_type: likeable.class.name, likeable_id: likeable.id).delete_all
      end

      private

        def self.like_for(liker, likeable)
          liked_by(liker).liking(likeable)
        end

        def self.validate_liker!(liker)
          raise Socialization::ArgumentError, "#{liker} is not liker!"        unless liker.respond_to?(:liker?) && liker.liker?
        end

        def self.validate_likeable!(likeable)
          raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:likeable?) && likeable.likeable?
        end
    end
  end
end