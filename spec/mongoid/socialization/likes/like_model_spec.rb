require "spec_helper"

module Mongoid::Socialization
  describe LikeModel do
    let(:user1)    { User.create!(name: "chamnap1") }
    let(:user2)    { User.create!(name: "chamnap2") }
    let(:admin1)   { Admin.create!(name: "chamnap1") }
    let(:admin2)   { Admin.create!(name: "chamnap2") }
    let(:product1) { Product.create!(name: "Laptop1") }
    let(:product2) { Product.create!(name: "Laptop2") }
    let(:page1)    { Page.create!(name: "Page1") }
    let(:page2)    { Page.create!(name: "Page2") }

    context "#like!" do
      it "returns true" do
        expect(LikeModel.like!(user1, product1)).to be_true
      end

      it "returns false after liked" do
        expect(LikeModel.like!(user1, product1)).to be_true

        expect(LikeModel.like!(user1, product1)).to be_false
      end

      it "increments #likes_count" do
        LikeModel.like!(user1, product1)
        expect(product1.likes_count(User)).to eq(1)

        LikeModel.like!(user2, product1)
        expect(product1.likes_count(User)).to eq(2)
      end

      it "pushs #liker_ids" do
        LikeModel.like!(user1, product1)
        expect(product1.liker_ids(User).count).to eq(1)
        expect(product1.liker_ids(User)).to include(user1.id)

        LikeModel.like!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(2)
        expect(product1.liker_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not liker" do
        expect {
          LikeModel.like!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          LikeModel.like!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unlike!" do
      it "returns true" do
        expect(LikeModel.like!(user1, product1)).to be_true

        expect(LikeModel.unlike!(user1, product1)).to be_true
      end

      it "returns false after unliked" do
        expect(LikeModel.unlike!(user1, product1)).to be_false
      end

      it "decrements #likes_count" do
        LikeModel.like!(user1, product1)
        LikeModel.like!(user2, product1)
        expect(product1.likes_count(User)).to eq(2)

        LikeModel.unlike!(user2, product1)
        expect(product1.likes_count(User)).to eq(1)

        LikeModel.unlike!(user1, product1)
        expect(product1.likes_count(User)).to eq(0)
      end

      it "pulls #liker_ids" do
        LikeModel.like!(user1, product1)
        LikeModel.like!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(2)

        LikeModel.unlike!(user1, product1)
        expect(product1.liker_ids(User).count).to eq(1)
        expect(product1.liker_ids(User)).to eq([user2.id])

        LikeModel.unlike!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(0)
        expect(product1.liker_ids(User)).to eq([])
      end

      it "raises exception when the actor is not liker" do
        expect {
          LikeModel.unlike!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          LikeModel.unlike!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_like!" do
      it "returns true after #like!" do
        LikeModel.like!(user1, product1)

        expect(LikeModel.toggle_like!(user1, product1)).to be_true
        expect(LikeModel.liked?(user1, product1)).to be_false
      end

      it "returns true after #unlike!" do
        LikeModel.unlike!(user1, product1)

        expect(LikeModel.toggle_like!(user1, product1)).to be_true
        expect(LikeModel.liked?(user1, product1)).to be_true
      end
    end

    context "#liked?" do
      it "returns true after liked" do
        LikeModel.like!(user1, product1)

        expect(LikeModel.liked?(user1, product1)).to be_true
      end

      it "returns false after unlike" do
        LikeModel.like!(user1, product1)
        expect(LikeModel.liked?(user1, product1)).to be_true

        LikeModel.unlike!(user1, product1)
        expect(LikeModel.liked?(user1, product1)).to be_false
      end

      it "raises exception when it is not likeable" do
        expect {
          LikeModel.liked?(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likeables" do
      it "returns likeables objects by klass" do
        LikeModel.like!(user1, product1)
        expect(LikeModel.likeables(user1, Product)).to eq([product1])

        LikeModel.like!(user1, page1)
        expect(LikeModel.likeables(user1, Page)).to eq([page1])
      end

      it "returns []" do
        expect(LikeModel.likeables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not likeable" do
        expect {
          LikeModel.likeables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the liker is not liker" do
        expect {
          LikeModel.likeables(:foo, Product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likers" do
      it "returns likers objects by klass" do
        LikeModel.like!(user1, product1)
        LikeModel.like!(user2, product1)

        LikeModel.like!(admin1, product1)
        LikeModel.like!(admin2, product1)

        expect(LikeModel.likers(product1, User)).to eq([user1, user2])
        expect(LikeModel.likers(product1, Admin)).to eq([admin1, admin2])
      end

      it "returns []" do
        expect(LikeModel.likers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not likeable" do
        expect {
          LikeModel.likers(product1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the likeable is not likeable" do
        expect {
          LikeModel.likers(:foo, User)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end