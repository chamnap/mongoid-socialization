module Mongoid
  module Mentionable
    extend ActiveSupport::Concern

    included do
      field :mentions_count, type: Hash, default: {}

      after_destroy { Socialization.mention_model.remove_mentioners(self) }
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

      update_attribute :mentions_count, hash
    end

    def mentioned_by?(mentioner)
      Socialization::MentionModel.mentioned?(mentioner, self)
    end

    def mentioners(klass)
      Socialization::MentionModel.mentioners(self, klass)
    end

    def mentioner_ids(klass)
      mentioners(klass).pluck("_id")
    end

  end
end