require "spec_helper"

module Mongoid::Socialization
  describe Follower do
    let(:follow_klass) { Mongoid::Socialization.follow_klass }
    let(:user1)        { User.create!(name: "chamnap1") }
    let(:user2)        { User.create!(name: "chamnap2") }
    let(:admin1)       { Admin.create!(name: "chamnap1") }
    let(:admin2)       { Admin.create!(name: "chamnap2") }
    let(:page1)        { Page.create!(name: "page1") }
    let(:page2)        { Page.create!(name: "page2") }

    context "#follow!" do
      it "should receive #follow! on Follow" do
        expect(follow_klass).to receive(:follow!).with(user1, user2)

        user1.follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.follow!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unfollow!" do
      it "should receive #unfollow! on Follow" do
        expect(follow_klass).to receive(:unfollow!).with(user1, user2)

        user1.unfollow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.unfollow!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_follow!" do
      it "should receive #toggle_follow! on Follow" do
        expect(follow_klass).to receive(:toggle_follow!).with(user1, user2)

        user1.toggle_follow!(user2)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.toggle_follow!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#followed?" do
      it "should receive #followed? on Follow" do
        expect(follow_klass).to receive(:followed?).with(user1, user2)

        user1.followed?(user2)
      end

      it "returns false when it is not followable" do
        expect(user1.followed?(:foo)).to eq(false)
      end
    end

    context "#followings" do
      it "should receive #followings on Follow" do
        expect(follow_klass).to receive(:followables).with(user1, User)

        user1.followings(User)
      end

      it "raises exception when it is not followable" do
        expect {
          user1.followings(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
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
        expect(user1.followings(Page)).to eq([page1])

        user1.destroy
        expect(user1.followings(Page)).to eq([])
        expect(page1.persisted?).to eq(true)
      end
    end

    context "#update_followings_count!" do
      it "updates followings_count per klass" do
        user1.update_followings_count!(Page, 1)
        user1.update_followings_count!(Product, 1)

        user1.reload
        expect(user1.followings_count).to eq(2)
        expect(user1.followings_count(Page)).to eq(1)
        expect(user1.followings_count(Product)).to eq(1)
      end
    end
  end
end