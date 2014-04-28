require "spec_helper"

describe User, type: :model do
  it { should have_field(:followings_count).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:following_ids).of_type(Array).with_default_value_of([]) }
end

module Mongoid
  describe Follower do
    let(:user1) { User.create!(name: "chamnap1") }
    let(:user2) { User.create!(name: "chamnap2") }

    context "#follow!" do
      it "should receive #follow! on Follows" do
        Socialization::Follows.should_receive(:follow!).with(user1, user2)

        user1.follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.follow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unfollow!" do
      it "should receive #unfollow! on Follows" do
        Socialization::Follows.should_receive(:unfollow!).with(user1, user2)

        user1.unfollow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.unfollow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_follow!" do
      it "should receive #toggle_follow! on Follows" do
        Socialization::Follows.should_receive(:toggle_follow!).with(user1, user2)

        user1.toggle_follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.toggle_follow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followed?" do
      it "should receive #followed? on Follows" do
        Socialization::Follows.should_receive(:followed?).with(user1, user2)

        user1.followed?(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.followed?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followables" do
      it "should receive #followables on Follows" do
        Socialization::Follows.should_receive(:followables).with(user1, User)

        user1.followables(User)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.followables(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end