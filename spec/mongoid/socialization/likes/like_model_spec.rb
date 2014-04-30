require "spec_helper"

module Mongoid::Socialization
  describe LikeModel do
    let(:user1)    { User.create!(name: "chamnap") }
    let(:user2)    { User.create!(name: "chhorn") }
    let(:product)  { Product.create!(name: "Laptop") }
    let(:page)     { Page.create!(name: "ABC") }

    context "#like!" do
      it "returns true" do
        expect(LikeModel.like!(user1, product)).to be_true
      end

      it "returns false after liked" do
        expect(LikeModel.like!(user1, product)).to be_true

        expect(LikeModel.like!(user1, product)).to be_false
      end

      it "increments #likes_count" do
        LikeModel.like!(user1, product)
        expect(product.likes_count(User)).to eq(1)

        LikeModel.like!(user2, product)
        expect(product.likes_count(User)).to eq(2)
      end

      it "pushs #liker_ids" do
        LikeModel.like!(user1, product)
        expect(product.liker_ids(User).count).to eq(1)
        expect(product.liker_ids(User)).to include(user1.id)

        LikeModel.like!(user2, product)
        expect(product.liker_ids(User).count).to eq(2)
        expect(product.liker_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not liker" do
        expect {
          LikeModel.like!(:foo, product)
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
        expect(LikeModel.like!(user1, product)).to be_true

        expect(LikeModel.unlike!(user1, product)).to be_true
      end

      it "returns false after unliked" do
        expect(LikeModel.unlike!(user1, product)).to be_false
      end

      it "decrements #likes_count" do
        LikeModel.like!(user1, product)
        LikeModel.like!(user2, product)
        expect(product.likes_count(User)).to eq(2)

        LikeModel.unlike!(user2, product)
        expect(product.likes_count(User)).to eq(1)

        LikeModel.unlike!(user1, product)
        expect(product.likes_count(User)).to eq(0)
      end

      it "pulls #liker_ids" do
        LikeModel.like!(user1, product)
        LikeModel.like!(user2, product)
        expect(product.liker_ids(User).count).to eq(2)

        LikeModel.unlike!(user1, product)
        expect(product.liker_ids(User).count).to eq(1)
        expect(product.liker_ids(User)).to eq([user2.id])

        LikeModel.unlike!(user2, product)
        expect(product.liker_ids(User).count).to eq(0)
        expect(product.liker_ids(User)).to eq([])
      end

      it "raises exception when the actor is not liker" do
        expect {
          LikeModel.unlike!(:foo, product)
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
        LikeModel.like!(user1, product)

        expect(LikeModel.toggle_like!(user1, product)).to be_true
        expect(LikeModel.liked?(user1, product)).to be_false
      end

      it "returns true after #unlike!" do
        LikeModel.unlike!(user1, product)

        expect(LikeModel.toggle_like!(user1, product)).to be_true
        expect(LikeModel.liked?(user1, product)).to be_true
      end
    end

    context "#liked?" do
      it "returns true after liked" do
        LikeModel.like!(user1, product)

        expect(LikeModel.liked?(user1, product)).to be_true
      end

      it "returns false after unlike" do
        LikeModel.like!(user1, product)
        expect(LikeModel.liked?(user1, product)).to be_true

        LikeModel.unlike!(user1, product)
        expect(LikeModel.liked?(user1, product)).to be_false
      end

      it "raises exception when it is not likeable" do
        expect {
          LikeModel.liked?(:foo, product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likeables" do
      it "returns likeables objects by klass" do
        LikeModel.like!(user1, product)
        expect(LikeModel.likeables(user1, Product)).to eq([product])

        LikeModel.like!(user1, page)
        expect(LikeModel.likeables(user1, Page)).to eq([page])
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
      it "returns likers objects" do
        LikeModel.like!(user1, product)
        LikeModel.like!(user2, product)

        expect(LikeModel.likers(product, User).to_a).to eq([user1, user2])
      end
    end
  end
end