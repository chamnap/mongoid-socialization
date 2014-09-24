module Mongoid
  module Socialization
    module ConversationModel
      extend ActiveSupport::Concern

      included do

        ## Indexes
        index({ participant_ids: 1 }, { background: true })

        ## Relations
        has_and_belongs_to_many :participants,  class_name: Mongoid::Socialization.conversationer_klass.to_s
        embeds_many             :messages,      class_name: Mongoid::Socialization.message_klass.to_s

        ## Validations
        validate                :validate_participants

        def last_sender
          messages.last.try(:sender)
        end

        def last_message
          messages.last
        end

        def receiver(sender)
          Mongoid::Socialization.conversationer_klass.find(participant_ids - [sender.id]).first
        end

        def create_message!(text, sender)
          messages.create!(text: text, sender: sender)
        end

        private

          def validate_participants
            errors.add(:participant_ids, "invalid participant_ids") if participants.length != 2
          end
      end

      module ClassMethods

        def create_with_two_participants!(participant, another_participant)
          find_with_participant_ids(participant.id, another_participant.id).
          find_and_modify({ "$set" => { updated_at: Time.now.utc }}, { upsert: true, new: true })
        end

        def find_or_initialize_with_participant_ids(*participant_ids)
          conversation = find_with_participant_ids(participant_ids.flatten)
          conversation.first || conversation.new
        end

        def find_with_participant_ids(*participant_ids)
          where(participant_ids: participant_ids.flatten.sort)
        end

      end
    end
  end
end