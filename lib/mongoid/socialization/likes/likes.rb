module Mongoid
  module Socialization
    module Likes

      def self.like!(liker, likeable)
        return false if liked?(liker, likeable)

        likeable.push              liker_ids: liker.id
        likeable.update_attribute  :likes_count, likeable.liker_ids.size

        update_liker(liker, likeable)
        true
      end

      def self.unlike!(liker, likeable)
        return false unless liked?(liker, likeable)

        likeable.pull              liker_ids: liker.id
        likeable.update_attribute  :likes_count, likeable.liker_ids.size

        update_liker(liker, likeable)
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

        likeable.liker_ids.include?(liker.id)
      end

      def self.likeables(liker, klass)
        validate_liker!(liker)
        validate_likeable!(klass)

        klass.where(:liker_ids.in => [liker.id])
      end

      def self.likers(likeable, klass)
        validate_liker!(klass)
        validate_likeable!(likeable)

        klass.where(:id.in => likeable.liker_ids)
      end

      private

        def self.validate_liker!(liker)
          raise Socialization::ArgumentError, "#{liker} is not liker!"        unless liker.respond_to?(:liker?) && liker.liker?
        end

        def self.validate_likeable!(likeable)
          raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:likeable?) && likeable.likeable?
        end

        def self.update_liker(liker, likeable)
          liker.add_to_set(likeable_klasses: likeable.class.name)
        end
    end
  end
end