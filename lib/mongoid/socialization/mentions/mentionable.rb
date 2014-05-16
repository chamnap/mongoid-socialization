module Mongoid
  module Socialization
    module Mentionable
      extend ActiveSupport::Concern

      included do
        attr_accessor           :mentioner, :unmentioner
        field                   :mentions_count, type: Hash, default: {}

        after_destroy           { mention_klass.remove_mentioners(self) }
        define_model_callbacks  :mention, :unmention
        observable              :mention, :unmention
      end

      def mentions_count(klass=nil)
        if klass.nil?
          read_attribute(:mentions_count).values.sum
        else
          read_attribute(:mentions_count)[klass.name]
        end
      end

      def update_mentions_count!(klass, count)
        hash = read_attribute(:mentions_count)
        hash[klass.name] = count

        set mentions_count: hash
      end

      def mentioned_by?(mentioner)
        mention_klass.mentioned?(mentioner, self)
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