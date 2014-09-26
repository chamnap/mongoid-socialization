module Mongoid
  module Socialization
    module MentionModel
      extend ActiveSupport::Concern

      included do

        # Indexes
        index({ mentionable_id: 1, mentionable_type: 1 }, { background: true })
        index({ mentioner_id: 1, mentioner_type: 1 },     { background: true })

        # Relations
        belongs_to  :mentioner,         polymorphic: true
        belongs_to  :mentionable,       polymorphic: true

        # Scopes
        scope       :mentioned_by,      ->(mentioner) {
          where(mentioner_type: mentioner.class.name, mentioner_id: mentioner.id)
        }

        scope       :mentioning,        ->(mentionable) {
          where(mentionable_type: mentionable.class.name, mentionable_id: mentionable.id)
        }
      end

      module ClassMethods
        def mention!(mentioner, mentionable)
          return false if mentioned?(mentioner, mentionable)

          create!(mentioner: mentioner, mentionable: mentionable)
          mentionable.update_mentioners_count!(mentioner.class, mentioners(mentionable, mentioner.class).size)
          mentioner.update_mentionables_count!(mentionable.class, mentionables(mentioner, mentionable.class).size)
          true
        end

        def unmention!(mentioner, mentionable)
          return false unless mentioned?(mentioner, mentionable)

          mention_for(mentioner, mentionable).delete_all
          mentionable.update_mentioners_count!(mentioner.class, mentioners(mentionable, mentioner.class).size)
          mentioner.update_mentionables_count!(mentionable.class, mentionables(mentioner, mentionable.class).size)
          true
        end

        def toggle_mention!(mentioner, mentionable)
          if mentioned?(mentioner, mentionable)
            unmention!(mentioner, mentionable)
          else
            mention!(mentioner, mentionable)
          end
        end

        def mentioned?(mentioner, mentionable)
          validate_mentioner!(mentioner)
          validate_mentionable!(mentionable)

          mention_for(mentioner, mentionable).present?
        end

        def mentionables(mentioner, klass)
          validate_mentioner!(mentioner)
          validate_mentionable!(klass)

          mentionable_ids = only(:mentionable_id).
            where(mentionable_type: klass.name).
            where(mentioner_type: mentioner.class.name).
            where(mentioner_id: mentioner.id).
            collect(&:mentionable_id)
          klass.where(:_id.in => mentionable_ids)
        end

        def mentioners(mentionable, klass)
          validate_mentioner!(klass)
          validate_mentionable!(mentionable)

          mentioner_ids = only(:mentioner_id).
            where(mentioner_type: klass.name).
            where(mentionable_type: mentionable.class.name).
            where(mentionable_id: mentionable.id).
            collect(&:mentioner_id)
          klass.where(:_id.in => mentioner_ids)
        end

        def remove_mentionables(mentioner)
          where(mentioner_type: mentioner.class.name, mentioner_id: mentioner.id).delete_all
        end

        def remove_mentioners(mentionable)
          where(mentionable_type: mentionable.class.name, mentionable_id: mentionable.id).delete_all
        end

        def mention_for(mentioner, mentionable)
          mentioned_by(mentioner).mentioning(mentionable)
        end

        def validate_mentioner!(mentioner)
          raise Socialization::Error.new(mentioner, "is not a mentioner")        unless mentioner.respond_to?(:mentioner?) && mentioner.mentioner?
        end

        def validate_mentionable!(mentionable)
          raise Socialization::Error.new(mentionable, "is not a mentionable")    unless mentionable.respond_to?(:mentionable?) && mentionable.mentionable?
        end
      end
    end
  end
end