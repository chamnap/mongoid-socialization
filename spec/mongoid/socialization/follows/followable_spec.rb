require "spec_helper"

module Mongoid::Socialization
  describe Followable do
    let(:follow_klass) { Mongoid::Socialization.follow_klass }
    let(:user1)        { User.create!(name: "chamnap1") }
    let(:user2)        { User.create!(name: "chamnap2") }
    let(:admin1)       { Admin.create!(name: "chamnap1") }
    let(:admin2)       { Admin.create!(name: "chamnap2") }
    let(:page)         { Page.create!(name: "page1") }

    context "#followed_by?" do
      it "should receive #followed_by? on Follow" do
        follow_klass.should_receive(:followed?).with(user1, user2)

        user2.followed_by?(user1)
      end

      it "raises exception when the Follow is not follower" do
        expect {
          user2.followed_by?(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#followers" do
      it "should receive #followers on Follow" do
        follow_klass.should_receive(:followers).with(user2, User)

        user2.followers(User)
      end
    end

    context "#followers_count" do
      it "returns total followers_count for all klasses" do
        user1.follow!(page)
        user2.follow!(page)

        expect(page.followers_count).to eq(2)
      end

      it "returns total followers_count for a specific klass" do
        user1.follow!(page)
        user2.follow!(page)

        admin1.follow!(page)
        admin2.follow!(page)

        expect(page.followers_count(User)).to eq(2)
        expect(page.followers_count(Admin)).to eq(2)
      end
    end

    context "#destroy" do
      it "removes follow_models when this followable is destroyed" do
        user1.follow!(page)
        expect(page.followers(User)).to eq([user1])

        page.destroy
        expect(page.followers(User)).to eq([])
        expect(user1.persisted?).to be_true
      end
    end

    context "#update_followers_count!" do
      it "updates followers_count per klass" do
        page.update_followers_count!(User, 1)
        page.update_followers_count!(Admin, 1)

        page.reload
        expect(page.followers_count).to eq(2)
        expect(page.followers_count(User)).to eq(1)
        expect(page.followers_count(Admin)).to eq(1)
      end
    end

    context "callbacks" do
      it "invokes #after_follow callbacks" do
        expect(page.after_follow_called).to be_false

        user1.follow!(page)

        expect(page.after_follow_called).to be_true
        expect(page.follower).to eq(user1)
      end

      it "invokes #after_unfollow callbacks" do
        user1.follow!(page)

        expect(page.after_follow_called).to be_true
        expect(page.after_unfollow_called).to be_false

        user1.unfollow!(page)

        expect(page.after_unfollow_called).to be_true
        expect(page.unfollower).to eq(user1)
      end
    end
  end
end