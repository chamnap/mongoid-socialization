module Mongoid
  module Socialization
    class Conversation
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in                collection: "mongoid_socialization_conversations"

      ## Indexes
      index({ participant_ids: 1 }, { background: true })

      ## Relations
      has_and_belongs_to_many :participants, class_name: Mongoid::Socialization.conversationer_klass.to_s
      embeds_many             :messages, class_name: Mongoid::Socialization.message_klass.to_s

      def self.create_with_two_participants!(participant, another_participant)
        where(participant_ids: [participant.id, another_participant.id].sort).
        find_and_modify({ "$set" => { updated_at: Time.now }}, { upsert: true, new: true })
      end

      def sender
        messages.last.try(:sender)
      end

      def receivers
        message = messages.last
        return [] if message.nil?

        message.participant_ids - message.sender.id
      end

      def create_message!(text, sender)
        messages.create!(text: text, sender: sender)
      end
    end
  end
end