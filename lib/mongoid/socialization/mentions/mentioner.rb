module Mongoid
  module Socialization
    module Mentioner
      extend ActiveSupport::Concern

      included do
        after_destroy { Mongoid::Socialization.mention_klass.remove_mentionables(self) }
      end

      def mention!(mentionable)
        Socialization.mention_klass.mention!(self, mentionable)
      end

      def unmention!(mentionable)
        Socialization.mention_klass.unmention!(self, mentionable)
      end

      def toggle_mention!(mentionable)
        Socialization.mention_klass.toggle_mention!(self, mentionable)
      end

      def mentioned?(mentionable)
        Socialization.mention_klass.mentioned?(self, mentionable)
      end

      def mentionables(klass)
        Socialization.mention_klass.mentionables(self, klass)
      end
    end
  end
end