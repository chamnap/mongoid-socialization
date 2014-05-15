module Mongoid
  module Socialization
    module Liker
      extend ActiveSupport::Concern

      included do
        after_destroy { Mongoid::Socialization.like_klass.remove_likeables(self) }
      end

      def like!(likeable)
        Socialization.like_klass.like!(self, likeable)
      end

      def unlike!(likeable)
        Socialization.like_klass.unlike!(self, likeable)
      end

      def toggle_like!(likeable)
        Socialization.like_klass.toggle_like!(self, likeable)
      end

      def liked?(likeable)
        Socialization.like_klass.liked?(self, likeable)
      end

      def likeables(klass)
        Socialization.like_klass.likeables(self, klass)
      end

      def likeable_ids(klass)
        likeables(klass).pluck("_id")
      end
    end
  end
end