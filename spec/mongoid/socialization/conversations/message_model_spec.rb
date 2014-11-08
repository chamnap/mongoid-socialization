require 'spec_helper'

module Mongoid::Socialization
  describe Message do
    let(:user1)   { User.create!(name: 'chamnap1') }
    let(:user2)   { User.create!(name: 'chamnap2') }
    let(:user3)   { User.create!(name: 'chamnap3') }
    after(:each)  { User.delete_all }

    context 'validate sender' do
      it 'invalid sender' do
        conversation = Conversation.create!(participant_ids: [user1.id, user2.id])
        message      = conversation.messages.create(sender: user3, text: 'hello')

        expect(message.errors[:sender]).to be_present
      end

      it 'valid senders' do
        conversation = Conversation.create!(participant_ids: [user1.id, user2.id])
        message1     = conversation.messages.create(sender: user1, text: 'hello')
        message2     = conversation.messages.create(sender: user2, text: 'hello')

        expect(message1.errors[:sender]).to be_blank
        expect(message2.errors[:sender]).to be_blank
      end
    end
  end
end