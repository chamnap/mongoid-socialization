require "spec_helper"

module Mongoid::Socialization
  describe FollowModel do
    let(:user1)    { User.create!(name: "chamnap1") }
    let(:user2)    { User.create!(name: "chamnap2") }
    let(:admin1)   { Admin.create!(name: "chamnap1") }
    let(:admin2)   { Admin.create!(name: "chamnap2") }
    let(:page1)    { Page.create!(name: "Page1") }
    let(:page2)    { Page.create!(name: "Page2") }

    context "#follow!" do
      it "returns true" do
        expect(FollowModel.follow!(user1, page1)).to be_true
      end

      it "returns false after followed" do
        expect(FollowModel.follow!(user1, page1)).to be_true

        expect(FollowModel.follow!(user1, page1)).to be_false
      end

      it "increments #followers_count" do
        FollowModel.follow!(user1, page1)
        expect(page1.followers_count(User)).to eq(1)

        FollowModel.follow!(user2, page1)
        expect(page1.followers_count(User)).to eq(2)
      end

      it "pushs #follower_ids" do
        FollowModel.follow!(user1, page1)
        expect(page1.follower_ids(User).count).to eq(1)
        expect(page1.follower_ids(User)).to include(user1.id)

        FollowModel.follow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(2)
        expect(page1.follower_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not follower" do
        expect {
          FollowModel.follow!(:foo, page1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not followable" do
        expect {
          FollowModel.follow!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unfollow!" do
      it "returns true" do
        expect(FollowModel.follow!(user1, page1)).to be_true

        expect(FollowModel.unfollow!(user1, page1)).to be_true
      end

      it "returns false after unfollowed" do
        expect(FollowModel.unfollow!(user1, page1)).to be_false
      end

      it "decrements #followers_count" do
        FollowModel.follow!(user1, page1)
        FollowModel.follow!(user2, page1)
        expect(page1.followers_count(User)).to eq(2)

        FollowModel.unfollow!(user2, page1)
        expect(page1.followers_count(User)).to eq(1)

        FollowModel.unfollow!(user1, page1)
        expect(page1.followers_count(User)).to eq(0)
      end

      it "pulls #follower_ids" do
        FollowModel.follow!(user1, page1)
        FollowModel.follow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(2)

        FollowModel.unfollow!(user1, page1)
        expect(page1.follower_ids(User).count).to eq(1)
        expect(page1.follower_ids(User)).to eq([user2.id])

        FollowModel.unfollow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(0)
        expect(page1.follower_ids(User)).to eq([])
      end

      it "raises exception when the actor is not follower" do
        expect {
          FollowModel.unfollow!(:foo, page1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not followable" do
        expect {
          FollowModel.unfollow!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_follow!" do
      it "returns true after #follow!" do
        FollowModel.follow!(user1, page1)

        expect(FollowModel.toggle_follow!(user1, page1)).to be_true
        expect(FollowModel.followed?(user1, page1)).to be_false
      end

      it "returns true after #unfollow!" do
        FollowModel.unfollow!(user1, page1)

        expect(FollowModel.toggle_follow!(user1, page1)).to be_true
        expect(FollowModel.followed?(user1, page1)).to be_true
      end
    end

    context "#followed?" do
      it "returns true after followed" do
        FollowModel.follow!(user1, page1)

        expect(FollowModel.followed?(user1, page1)).to be_true
      end

      it "returns false after unfollow" do
        FollowModel.follow!(user1, page1)
        expect(FollowModel.followed?(user1, page1)).to be_true

        FollowModel.unfollow!(user1, page1)
        expect(FollowModel.followed?(user1, page1)).to be_false
      end

      it "raises exception when it is not followable" do
        expect {
          FollowModel.followed?(:foo, page1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followables" do
      it "returns followables objects by klass" do
        FollowModel.follow!(user1, page1)
        expect(FollowModel.followables(user1, Page)).to eq([page1])

        FollowModel.follow!(user1, user2)
        expect(FollowModel.followables(user1, User)).to eq([user2])
      end

      it "returns []" do
        expect(FollowModel.followables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not followable" do
        expect {
          FollowModel.followables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the follower is not follower" do
        expect {
          FollowModel.followables(:foo, Page)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followers" do
      it "returns followers objects by klass" do
        FollowModel.follow!(user1, page1)
        FollowModel.follow!(user2, page1)

        FollowModel.follow!(admin1, page1)
        FollowModel.follow!(admin2, page1)

        expect(FollowModel.followers(page1, User)).to eq([user1, user2])
        expect(FollowModel.followers(page1, Admin)).to eq([admin1, admin2])
      end

      it "returns []" do
        expect(FollowModel.followers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not followable" do
        expect {
          FollowModel.followers(page1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the followable is not followable" do
        expect {
          FollowModel.followers(:foo, User)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end