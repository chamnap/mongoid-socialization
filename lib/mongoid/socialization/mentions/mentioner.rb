module Mongoid
  module Socialization
    module Mentioner
      extend ActiveSupport::Concern

      included do
        after_destroy { mention_klass.remove_mentionables(self) }
      end

      def mention!(mentionable)
        mention_klass.validate_mentionable!(mentionable)

        mentionable.run_callbacks :mention do
          mention_klass.mention!(self, mentionable)
          mentionable.mentioner = self
        end
      end

      def unmention!(mentionable)
        mention_klass.validate_mentionable!(mentionable)

        mentionable.run_callbacks :unmention do
          mention_klass.unmention!(self, mentionable)
          mentionable.unmentioner = self
        end
      end

      def toggle_mention!(mentionable)
        mention_klass.toggle_mention!(self, mentionable)
      end

      def mentioned?(mentionable)
        mention_klass.mentioned?(self, mentionable)
      end

      def mentionables(klass)
        mention_klass.mentionables(self, klass)
      end
    end
  end
end