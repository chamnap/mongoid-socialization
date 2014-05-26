require "spec_helper"

module Mongoid::Socialization
  describe FollowModel do
    let(:follow_klass) { Mongoid::Socialization.follow_klass }
    let(:user1)        { User.create!(name: "chamnap1") }
    let(:user2)        { User.create!(name: "chamnap2") }
    let(:admin1)       { Admin.create!(name: "chamnap1") }
    let(:admin2)       { Admin.create!(name: "chamnap2") }
    let(:page1)        { Page.create!(name: "Page1") }
    let(:page2)        { Page.create!(name: "Page2") }

    context "#follow!" do
      it "returns true" do
        expect(follow_klass.follow!(user1, page1)).to be_true
      end

      it "returns false after followed" do
        expect(follow_klass.follow!(user1, page1)).to be_true

        expect(follow_klass.follow!(user1, page1)).to be_false
      end

      it "increments #followers_count" do
        follow_klass.follow!(user1, page1)
        expect(page1.followers_count(User)).to eq(1)

        follow_klass.follow!(user2, page1)
        expect(page1.followers_count(User)).to eq(2)
      end

      it "pushs #follower_ids" do
        follow_klass.follow!(user1, page1)
        expect(page1.follower_ids(User).count).to eq(1)
        expect(page1.follower_ids(User)).to include(user1.id)

        follow_klass.follow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(2)
        expect(page1.follower_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not follower" do
        expect {
          follow_klass.follow!(:foo, page1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not followable" do
        expect {
          follow_klass.follow!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unfollow!" do
      it "returns true" do
        expect(follow_klass.follow!(user1, page1)).to be_true

        expect(follow_klass.unfollow!(user1, page1)).to be_true
      end

      it "returns false after unfollowed" do
        expect(follow_klass.unfollow!(user1, page1)).to be_false
      end

      it "decrements #followers_count" do
        follow_klass.follow!(user1, page1)
        follow_klass.follow!(user2, page1)
        expect(page1.followers_count(User)).to eq(2)

        follow_klass.unfollow!(user2, page1)
        expect(page1.followers_count(User)).to eq(1)

        follow_klass.unfollow!(user1, page1)
        expect(page1.followers_count(User)).to eq(0)
      end

      it "pulls #follower_ids" do
        follow_klass.follow!(user1, page1)
        follow_klass.follow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(2)

        follow_klass.unfollow!(user1, page1)
        expect(page1.follower_ids(User).count).to eq(1)
        expect(page1.follower_ids(User)).to eq([user2.id])

        follow_klass.unfollow!(user2, page1)
        expect(page1.follower_ids(User).count).to eq(0)
        expect(page1.follower_ids(User)).to eq([])
      end

      it "raises exception when the actor is not follower" do
        expect {
          follow_klass.unfollow!(:foo, page1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not followable" do
        expect {
          follow_klass.unfollow!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_follow!" do
      it "returns true after #follow!" do
        follow_klass.follow!(user1, page1)

        expect(follow_klass.toggle_follow!(user1, page1)).to be_true
        expect(follow_klass.followed?(user1, page1)).to be_false
      end

      it "returns true after #unfollow!" do
        follow_klass.unfollow!(user1, page1)

        expect(follow_klass.toggle_follow!(user1, page1)).to be_true
        expect(follow_klass.followed?(user1, page1)).to be_true
      end
    end

    context "#followed?" do
      it "returns true after followed" do
        follow_klass.follow!(user1, page1)

        expect(follow_klass.followed?(user1, page1)).to be_true
      end

      it "returns false after unfollow" do
        follow_klass.follow!(user1, page1)
        expect(follow_klass.followed?(user1, page1)).to be_true

        follow_klass.unfollow!(user1, page1)
        expect(follow_klass.followed?(user1, page1)).to be_false
      end

      it "raises exception when it is not followable" do
        expect {
          follow_klass.followed?(:foo, page1)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#followables" do
      it "returns followables objects by klass" do
        follow_klass.follow!(user1, page1)
        expect(follow_klass.followables(user1, Page)).to eq([page1])

        follow_klass.follow!(user1, user2)
        expect(follow_klass.followables(user1, User)).to eq([user2])
      end

      it "returns []" do
        expect(follow_klass.followables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not followable" do
        expect {
          follow_klass.followables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the follower is not follower" do
        expect {
          follow_klass.followables(:foo, Page)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#followers" do
      it "returns followers objects by klass" do
        follow_klass.follow!(user1, page1)
        follow_klass.follow!(user2, page1)

        follow_klass.follow!(admin1, page1)
        follow_klass.follow!(admin2, page1)

        expect(follow_klass.followers(page1, User)).to eq([user1, user2])
        expect(follow_klass.followers(page1, Admin)).to eq([admin1, admin2])
      end

      it "returns []" do
        expect(follow_klass.followers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not followable" do
        expect {
          follow_klass.followers(page1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the followable is not followable" do
        expect {
          follow_klass.followers(:foo, User)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end
  end
end