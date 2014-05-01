require "spec_helper"

describe User, type: :model do
  it { should have_field(:followers_count).of_type(Hash).with_default_value_of({}) }
end

module Mongoid
  describe Followable do
    let(:user1)   { User.create!(name: "chamnap1") }
    let(:user2)   { User.create!(name: "chamnap2") }
    let(:admin1)  { Admin.create!(name: "chamnap1") }
    let(:admin2)  { Admin.create!(name: "chamnap2") }
    let(:page)    { Page.create!(name: "page1") }

    context "#followed_by?" do
      it "should receive #followed_by? on FollowModel" do
        Socialization::FollowModel.should_receive(:followed?).with(user1, user2)

        user2.followed_by?(user1)
      end

      it "raises exception when the FollowModel is not follower" do
        expect {
          user2.followed_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#followers" do
      it "should receive #followers on FollowModel" do
        Socialization::FollowModel.should_receive(:followers).with(user2, User)

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
  end
end