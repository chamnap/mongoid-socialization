module Mongoid
  module Socialization
    module LikeModel
      extend ActiveSupport::Concern

      included do

        # Indexes
        index({ likeable_id: 1, likeable_type: 1 }, { background: true })
        index({ liker_id: 1, liker_type: 1 }, { background: true })

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
      end

      module ClassMethods
        def like!(liker, likeable)
          return false if liked?(liker, likeable)

          create!(liker: liker, likeable: likeable)
          likeable.update_likers_count!(liker.class, likers(likeable, liker.class).size)
          liker.update_likeables_count!(likeable.class, likeables(liker, likeable.class).size)
          true
        end

        def unlike!(liker, likeable)
          return false unless liked?(liker, likeable)

          like_for(liker, likeable).delete_all
          likeable.update_likers_count!(liker.class, likers(likeable, liker.class).size)
          liker.update_likeables_count!(likeable.class, likeables(liker, likeable.class).size)
          true
        end

        def toggle_like!(liker, likeable)
          if liked?(liker, likeable)
            unlike!(liker, likeable)
          else
            like!(liker, likeable)
          end
        end

        def liked?(liker, likeable)
          validate_liker!(liker)
          validate_likeable!(likeable)

          like_for(liker, likeable).present?
        end

        def likeables(liker, klass)
          validate_liker!(liker)
          validate_likeable!(klass)

          likeable_ids = only(:likeable_id).
            where(likeable_type: klass.name).
            where(liker_type: liker.class.name).
            where(liker_id: liker.id).
            collect(&:likeable_id)
          klass.where(:_id.in => likeable_ids)
        end

        def likers(likeable, klass)
          validate_liker!(klass)
          validate_likeable!(likeable)

          liker_ids = only(:liker_id).
            where(liker_type: klass.name).
            where(likeable_type: likeable.class.name).
            where(likeable_id: likeable.id).
            collect(&:liker_id)
          klass.where(:_id.in => liker_ids)
        end

        def remove_likeables(liker)
          where(liker_type: liker.class.name, liker_id: liker.id).delete_all
        end

        def remove_likers(likeable)
          where(likeable_type: likeable.class.name, likeable_id: likeable.id).delete_all
        end

        def like_for(liker, likeable)
          liked_by(liker).liking(likeable)
        end

        def validate_liker!(liker)
          raise Socialization::Error.new(liker, "is not a liker")        unless liker.respond_to?(:liker?) && liker.liker?
        end

        def validate_likeable!(likeable)
          raise Socialization::Error.new(likeable, "is not a likeable")  unless likeable.respond_to?(:likeable?) && likeable.likeable?
        end
      end
    end
  end
end