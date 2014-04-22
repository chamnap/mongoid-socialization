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

      module ClassMethods
        def likeable?
          included_modules.include?(Mongoid::Likeable)
        end

        def liker?
          included_modules.include?(Mongoid::Liker)
        end
      end
    end
  end
end