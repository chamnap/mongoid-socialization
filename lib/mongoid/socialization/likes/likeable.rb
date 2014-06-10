module Mongoid
  module Socialization
    module Likeable
      extend ActiveSupport::Concern

      included do
        attr_accessor           :liker, :unliker
        field                   :likers_count, type: Hash, default: {}

        after_destroy           { like_klass.remove_likers(self) }
        define_model_callbacks  :like, :unlike
        observable              :like, :unlike
      end

      def likers_count(klass=nil)
        if klass.nil?
          read_attribute(:likers_count).values.sum
        else
          read_attribute(:likers_count).fetch(klass.name, 0)
        end
      end

      def update_likers_count!(klass, count)
        hash = read_attribute(:likers_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:likers_count, hash)
        else
          set(likers_count: hash)
        end
      end

      def liked_by?(liker)
        like_klass.liked?(liker, self)
      rescue
        false
      end

      def likers(klass)
        like_klass.likers(self, klass)
      end

      def liker_ids(klass)
        likers(klass).pluck("_id")
      end
    end
  end
end