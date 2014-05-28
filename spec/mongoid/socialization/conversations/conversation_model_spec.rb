require "spec_helper"

module Mongoid::Socialization
  describe Conversation do
    let(:user1) { User.create!(name: "chamnap1") }
    let(:user2) { User.create!(name: "chamnap2") }
    let(:user3) { User.create!(name: "chamnap3") }

    context "validate_participants" do
      it "fails validation when participant_ids is invalid" do
        conversation = Conversation.new(participant_ids: ["invalid", "invalid"])
        conversation.valid?

        expect(conversation.errors[:participant_ids]).to be_present
      end

      it "passes validation when there is two participant_ids" do
        conversation = Conversation.new(participant_ids: [user1.id, user2.id])
        conversation.valid?

        expect(conversation.errors[:participant_ids]).not_to be_present
      end

      it "fails validation when there is not two participant_ids" do
        conversation = Conversation.new(participant_ids: [user1.id, user2.id, user3.id])
        conversation.valid?

        expect(conversation.errors[:participant_ids]).to be_present
      end
    end

    context "methods" do
      let(:conversation) { Conversation.create!(participants: [user1, user2]) }

      it "#find_with_participant_ids in reverse order" do
        result = Conversation.find_with_participant_ids(*conversation.participant_ids.reverse).first

        expect(result).to eq(conversation)
      end

      it "#find_with_participant_ids in normal order" do
        result = Conversation.find_with_participant_ids(*conversation.participant_ids).first

        expect(result).to eq(conversation)
      end

      it "#sender" do
        conversation.create_message!("Hello", user2)

        expect(conversation.sender).to eq(user2)
      end
    end
  end
end