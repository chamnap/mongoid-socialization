require "spec_helper"

describe Mongoid::Likeable do
  let(:user1)    { User.create!(name: "chamnap") }
  let(:user2)    { User.create!(name: "chhorn") }
  let(:product)  { Product.create!(name: "Laptop") }

  context "#like!" do
    it "returns true" do
      expect(product.like!(user1)).to be_true
    end

    it "returns false after liked" do
      expect(product.like!(user1)).to be_true

      expect(product.like!(user1)).to be_false
    end

    it "increments #likes_count" do
      product.like!(user1)
      expect(product.likes_count).to eq(1)

      product.like!(user2)
      expect(product.likes_count).to eq(2)
    end

    it "pushs #liker_ids" do
      product.like!(user1)
      expect(product.liker_ids.count).to eq(1)
      expect(product.liker_ids).to include(user1.id)

      product.like!(user2)
      expect(product.liker_ids.count).to eq(2)
      expect(product.liker_ids).to include(user2.id)
    end

    it "raises exception when the victim is not liker" do
      expect {
        product.like!(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end

  context "#unlike!" do
    it "returns true" do
      expect(product.like!(user1)).to be_true

      expect(product.unlike!(user1)).to be_true
    end

    it "returns false after unliked" do
      expect(product.unlike!(user1)).to be_false
    end

    it "decrements #likes_count" do
      product.like!(user1)
      product.like!(user2)
      expect(product.likes_count).to eq(2)

      product.unlike!(user2)
      expect(product.likes_count).to eq(1)

      product.unlike!(user1)
      expect(product.likes_count).to eq(0)
    end

    it "pulls #liker_ids" do
      product.like!(user1)
      product.like!(user2)
      expect(product.liker_ids.count).to eq(2)

      product.unlike!(user1)
      expect(product.liker_ids.count).to eq(1)
      expect(product.liker_ids).to eq([user2.id])

      product.unlike!(user2)
      expect(product.liker_ids.count).to eq(0)
      expect(product.liker_ids).to eq([])
    end

    it "raises exception when the victim is not liker" do
      expect {
        product.unlike!(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end

  context "#liked_by?" do
    it "returns true after liked" do
      product.like!(user1)

      expect(product.liked_by?(user1)).to be_true
    end

    it "returns false after unlike" do
      product.like!(user1)
      expect(product.liked_by?(user1)).to be_true

      product.unlike!(user1)
      expect(product.liked_by?(user1)).to be_false
    end

    it "raises exception when the victim is not liker" do
      expect {
        product.liked_by?(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end
end