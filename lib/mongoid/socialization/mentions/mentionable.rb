module Mongoid
  module Socialization
    module Mentionable
      extend ActiveSupport::Concern

      included do
        attr_accessor           :mentioner, :unmentioner
        field                   :mentioners_count, type: Hash, default: {}

        after_destroy           { mention_klass.remove_mentioners(self) }
        define_model_callbacks  :mention, :unmention
        observable              :mention, :unmention
      end

      def mentioners_count(klass=nil)
        if klass.nil?
          read_attribute(:mentioners_count).values.sum
        else
          read_attribute(:mentioners_count)[klass.name]
        end
      end

      def update_mentioners_count!(klass, count)
        hash = read_attribute(:mentioners_count)
        hash[klass.name] = count

        if Mongoid::VERSION.start_with?("3.1")
          set(:mentioners_count, hash)
        else
          set(mentioners_count: hash)
        end
      end

      def mentioned_by?(mentioner)
        mention_klass.mentioned?(mentioner, self)
      rescue
        false
      end

      def mentioners(klass)
        mention_klass.mentioners(self, klass)
      end

      def mentioner_ids(klass)
        mentioners(klass).pluck("_id")
      end
    end
  end
end