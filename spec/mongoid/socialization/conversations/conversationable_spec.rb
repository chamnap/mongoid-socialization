require "spec_helper"

describe User, "#send_message!" do
  let(:user1) { User.create(name: "chamnap1") }
  let(:user2) { User.create(name: "chamnap2") }
  let(:user3) { User.create(name: "chamnap3") }

  context "user1 send messages to user2" do
    before do
      @message = user1.send_message!("Hello, how are you?", user2)
    end

    it "returns message object" do
      expect(@message).to be_instance_of(Mongoid::Socialization.message_klass)
    end

    it "returns @message object with correct data" do
      expect(@message.text).to eq("Hello, how are you?")
      expect(@message.sender).to eq(user1)
      expect(@message.persisted?).to be_true
      expect(@message.conversation.participant_ids.sort).to eq([user1.id, user2.id].sort)
    end

    it "#conversation_ids" do
      expect(user1.conversation_ids).to be_present
      expect(user1.conversation_ids).to eq(user2.conversation_ids)
    end

    it "has the same conversation" do
      expect(user1.conversations.length).to eq(1)
      expect(user2.conversations.length).to eq(1)
    end
  end

  context "user2 replies back to user1" do
    before do
      user1.send_message!("Hello, how are you?", user2)
      user2.send_message!("I'm fine. And you?", user1)
    end

    it "has the same conversation" do
      expect(user1.conversation_ids).to eq(user2.conversation_ids)
    end

    it "has only one conversation" do
      expect(user1.conversations.length).to eq(1)
      expect(user2.conversations.length).to eq(1)
    end
  end

  context "user1 replied back to user2, user2 send to user3, user3 send to user1" do
    before do
      user1.send_message!("Hello, how are you?", user2)
      user2.send_message!("I'm fine. And you?", user1)
      user1.send_message!("I'm fine too.", user2)
      user2.send_message!("Where is your shop?", user3)
      user3.send_message!("What time do you work?", user1)
    end

    let(:conversation1_2) { user1.find_conversation_with(user2) }
    let(:conversation1_3) { user1.find_conversation_with(user3) }
    let(:conversation2_3) { user2.find_conversation_with(user3) }

    it "conversation1_2 has 3 messages" do
      expect(conversation1_2.messages.count).to eq(3)

      expect(conversation1_2.messages[0].text).to eq("Hello, how are you?")
      expect(conversation1_2.messages[1].text).to eq("I'm fine. And you?")
      expect(conversation1_2.messages[2].text).to eq("I'm fine too.")
    end

    it "conversation1_3 has 1 message" do
      expect(conversation1_3.messages.count).to eq(1)
      expect(conversation1_3.messages.last.sender).to eq(user3)
      expect(conversation1_3.messages.last.text).to eq("What time do you work?")
    end

    it "conversation2_3 has 1 message" do
      expect(conversation2_3.messages.count).to eq(1)
      expect(conversation2_3.messages.last.sender).to eq(user2)
      expect(conversation2_3.messages.last.text).to eq("Where is your shop?")
    end
  end
end