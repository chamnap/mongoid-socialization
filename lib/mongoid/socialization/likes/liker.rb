module Mongoid
  module Socialization
    module Liker
      extend ActiveSupport::Concern

      included do
        field           :likeables_count, type: Hash,  default: {}

        after_destroy   { like_klass.remove_likeables(self) }
      end

      def likeables_count(klass=nil)
        if klass.nil?
          read_attribute(:likeables_count).values.sum
        else
          read_attribute(:likeables_count).fetch(klass.name, 0)
        end
      end

      def update_likeables_count!(klass, count)
        hash = read_attribute(:likeables_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:likeables_count, hash)
        else
          set(likeables_count: hash)
        end
      end

      def like!(likeable)
        like_klass.validate_likeable!(likeable)

        likeable.run_callbacks :like do
          like_klass.like!(self, likeable)
          likeable.liker = self
        end
      end

      def unlike!(likeable)
        like_klass.validate_likeable!(likeable)

        likeable.run_callbacks :unlike do
          like_klass.unlike!(self, likeable)
          likeable.unliker = self
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