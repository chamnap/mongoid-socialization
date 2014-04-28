require "spec_helper"

module Mongoid::Socialization
  describe Likes do
    let(:user1)    { User.create!(name: "chamnap") }
    let(:user2)    { User.create!(name: "chhorn") }
    let(:product)  { Product.create!(name: "Laptop") }
    let(:page)     { Page.create!(name: "ABC") }

    context "#like!" do
      it "returns true" do
        expect(Likes.like!(user1, product)).to be_true
      end

      it "returns false after liked" do
        expect(Likes.like!(user1, product)).to be_true

        expect(Likes.like!(user1, product)).to be_false
      end

      it "increments #likes_count" do
        Likes.like!(user1, product)
        expect(product.likes_count).to eq(1)

        Likes.like!(user2, product)
        expect(product.likes_count).to eq(2)
      end

      it "pushs #liker_ids" do
        Likes.like!(user1, product)
        expect(product.liker_ids.count).to eq(1)
        expect(product.liker_ids).to include(user1.id)

        Likes.like!(user2, product)
        expect(product.liker_ids.count).to eq(2)
        expect(product.liker_ids).to include(user2.id)
      end

      it "updates likeable_klasses in liker" do
        Likes.like!(user1, product)
        expect(user1.likeable_klasses).to eq(["Product"])

        Likes.like!(user1, page)
        expect(user1.likeable_klasses).to eq(["Product", "Page"])
      end

      it "raises exception when the actor is not liker" do
        expect {
          Likes.like!(:foo, product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          Likes.like!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unlike!" do
      it "returns true" do
        expect(Likes.like!(user1, product)).to be_true

        expect(Likes.unlike!(user1, product)).to be_true
      end

      it "returns false after unliked" do
        expect(Likes.unlike!(user1, product)).to be_false
      end

      it "decrements #likes_count" do
        Likes.like!(user1, product)
        Likes.like!(user2, product)
        expect(product.likes_count).to eq(2)

        Likes.unlike!(user2, product)
        expect(product.likes_count).to eq(1)

        Likes.unlike!(user1, product)
        expect(product.likes_count).to eq(0)
      end

      it "pulls #liker_ids" do
        Likes.like!(user1, product)
        Likes.like!(user2, product)
        expect(product.liker_ids.count).to eq(2)

        Likes.unlike!(user1, product)
        expect(product.liker_ids.count).to eq(1)
        expect(product.liker_ids).to eq([user2.id])

        Likes.unlike!(user2, product)
        expect(product.liker_ids.count).to eq(0)
        expect(product.liker_ids).to eq([])
      end

      it "raises exception when the actor is not liker" do
        expect {
          Likes.unlike!(:foo, product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          Likes.unlike!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_like!" do
      it "returns true after #like!" do
        Likes.like!(user1, product)

        expect(Likes.toggle_like!(user1, product)).to be_true
        expect(Likes.liked?(user1, product)).to be_false
      end

      it "returns true after #unlike!" do
        Likes.unlike!(user1, product)

        expect(Likes.toggle_like!(user1, product)).to be_true
        expect(Likes.liked?(user1, product)).to be_true
      end
    end

    context "#liked?" do
      it "returns true after liked" do
        Likes.like!(user1, product)

        expect(Likes.liked?(user1, product)).to be_true
      end

      it "returns false after unlike" do
        Likes.like!(user1, product)
        expect(Likes.liked?(user1, product)).to be_true

        Likes.unlike!(user1, product)
        expect(Likes.liked?(user1, product)).to be_false
      end

      it "raises exception when it is not likeable" do
        expect {
          Likes.liked?(:foo, product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likeables" do
      it "returns likeables objects by klass" do
        Likes.like!(user1, product)
        expect(Likes.likeables(user1, Product)).to eq([product])

        Likes.like!(user1, page)
        expect(Likes.likeables(user1, Page)).to eq([page])
      end

      it "raises exception when the klass is not likeable" do
        expect {
          Likes.likeables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the liker is not liker" do
        expect {
          Likes.likeables(:foo, Product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likers" do
      it "returns likers objects" do
        Likes.like!(user1, product)
        Likes.like!(user2, product)

        expect(Likes.likers(product, User).to_a).to eq([user1, user2])
      end
    end
  end
end