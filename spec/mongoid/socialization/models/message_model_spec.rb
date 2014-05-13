require "spec_helper"

module Mongoid::Socialization
  describe MessageModel, type: :model do
    it { should be_timestamped_document }
    it { should have_field(:is_seen).of_type(Mongoid::Socialization.boolean_klass).with_default_value_of(false) }
    it { should have_field(:seen_at).of_type(Time) }
    it { should have_field(:text).of_type(String) }

    it { should be_embedded_in(:conversation) }
    it { should belong_to(:sender).of_type(Mongoid::Socialization.conversationer_model) }

    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:sender) }
  end
end