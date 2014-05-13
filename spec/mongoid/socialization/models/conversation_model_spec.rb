require "spec_helper"

module Mongoid::Socialization
  describe ConversationModel, type: :model do
    it { should be_timestamped_document }
    it { should have_and_belong_to_many(:participants).of_type(Mongoid::Socialization.conversationer_model) }
    it { should embed_many(:messages).of_type(Mongoid::Socialization.message_model) }
  end
end