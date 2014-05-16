module Mongoid
  module Socialization
    module Liker
      extend ActiveSupport::Concern

      included do
        after_destroy   { like_klass.remove_likeables(self) }
      end

      def like!(likeable)
        like_klass.validate_likeable!(likeable)

        likeable.run_callbacks :like do
          like_klass.like!(self, likeable)
        end
      end

      def unlike!(likeable)
        like_klass.validate_likeable!(likeable)

        likeable.run_callbacks :unlike do
          like_klass.unlike!(self, likeable)
        end
      end

      def toggle_like!(likeable)
        like_klass.toggle_like!(self, likeable)
      end

      def liked?(likeable)
        like_klass.liked?(self, likeable)
      end

      def likeables(klass)
        like_klass.likeables(self, klass)
      end

      def likeable_ids(klass)
        likeables(klass).pluck("_id")
      end
    end
  end
end