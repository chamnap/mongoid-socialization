module Mongoid
  module Socialization
    module DocumentAdditions
      extend ActiveSupport::Concern

      def likeable?
        self.class.likeable?
      end

      def liker?
        self.class.liker?
      end

      def followable?
        self.class.followable?
      end

      def follower?
        self.class.follower?
      end

      module ClassMethods
        def likeable?
          included_modules.include?(Mongoid::Likeable)
        end

        def liker?
          included_modules.include?(Mongoid::Liker)
        end

        def followable?
          included_modules.include?(Mongoid::Followable)
        end

        def follower?
          included_modules.include?(Mongoid::Follower)
        end
      end
    end
  end
end