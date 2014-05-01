require "spec_helper"

describe User, type: :model do
  it { should have_field(:followings_count).of_type(Hash).with_default_value_of({}) }
end

module Mongoid
  describe Follower do
    let(:user1)   { User.create!(name: "chamnap1") }
    let(:user2)   { User.create!(name: "chamnap2") }
    let(:admin1)  { Admin.create!(name: "chamnap1") }
    let(:admin2)  { Admin.create!(name: "chamnap2") }
    let(:page1)   { Page.create!(name: "page1") }
    let(:page2)   { Page.create!(name: "page2") }

    context "#follow!" do
      it "should receive #follow! on FollowModel" do
        Socialization::FollowModel.should_receive(:follow!).with(user1, user2)

        user1.follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.follow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unfollow!" do
      it "should receive #unfollow! on FollowModel" do
        Socialization::FollowModel.should_receive(:unfollow!).with(user1, user2)

        user1.unfollow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.unfollow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_follow!" do
      it "should receive #toggle_follow! on FollowModel" do
        Socialization::FollowModel.should_receive(:toggle_follow!).with(user1, user2)

        user1.toggle_follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.toggle_follow!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followed?" do
      it "should receive #followed? on FollowModel" do
        Socialization::FollowModel.should_receive(:followed?).with(user1, user2)

        user1.followed?(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.followed?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followables" do
      it "should receive #followables on FollowModel" do
        Socialization::FollowModel.should_receive(:followables).with(user1, User)

        user1.followables(User)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.followables(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followings_count" do
      it "returns total followings_count for all klasses" do
        user1.follow!(page1)
        user1.follow!(page2)

        expect(user1.followings_count).to eq(2)
      end

      it "returns total followings_count for a specific klass" do
        user1.follow!(page1)
        user1.follow!(page2)

        user1.follow!(admin1)
        user1.follow!(admin2)

        expect(user1.followings_count(Page)).to eq(2)
        expect(user1.followings_count(Admin)).to eq(2)
      end
    end

    context "#destroy" do
      it "removes follow_models when this follower is destroyed" do
        user1.follow!(page1)
        expect(user1.followables(Page)).to eq([page1])

        user1.destroy
        expect(user1.followables(Page)).to eq([])
        expect(page1.persisted?).to be_true
      end
    end
  end
end