module Mongoid
  module Mentioner
    extend ActiveSupport::Concern

    included do
      after_destroy { Mongoid::Socialization.mention_model.remove_mentionables(self) }
    end

    def mention!(mentionable)
      Socialization::MentionModel.mention!(self, mentionable)
    end

    def unmention!(mentionable)
      Socialization::MentionModel.unmention!(self, mentionable)
    end

    def toggle_mention!(mentionable)
      Socialization::MentionModel.toggle_mention!(self, mentionable)
    end

    def mentioned?(mentionable)
      Socialization::MentionModel.mentioned?(self, mentionable)
    end

    def mentionables(klass)
      Socialization::MentionModel.mentionables(self, klass)
    end
  end
end