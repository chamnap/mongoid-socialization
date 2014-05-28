module Mongoid
  module Socialization
    module Conversationable
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :conversations, class_name: Mongoid::Socialization.conversation_klass.to_s
      end

      def make_conversation!(another_participant)
        conversation = Mongoid::Socialization.conversation_klass.create_with_two_participants!(self, another_participant)
        self.conversations                << conversation
        another_participant.conversations << conversation

        conversation
      end

      def conversation_with(another_participant)
        Mongoid::Socialization.conversation_klass.find_with_participant_ids(id, another_participant.id).first
      end

      def send_message!(text, another_participant)
        conversation = make_conversation!(another_participant)

        conversation.create_message!(text, self)
      end
    end
  end
end