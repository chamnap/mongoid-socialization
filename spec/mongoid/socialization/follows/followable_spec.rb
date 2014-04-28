require "spec_helper"

describe User, type: :model do
  it { should have_field(:followers_count).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:follower_ids).of_type(Array).with_default_value_of([]) }
end

module Mongoid
  describe Followable do
    let(:user1) { User.create!(name: "chamnap1") }
    let(:user2) { User.create!(name: "chamnap2") }

    context "#followed_by?" do
      it "should receive #followed_by? on Follows" do
        Socialization::Follows.should_receive(:followed?).with(user1, user2)

        user2.followed_by?(user1)
      end

      it "raises exception when the Follows is not follower" do
        expect {
          user2.followed_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followers" do
      it "should receive #followers on Follows" do
        Socialization::Follows.should_receive(:followers).with(user2, User)

        user2.followers(User)
      end
    end
  end
end