require "spec_helper"

module Mongoid
  describe Likeable do
    let(:user)    { User.create!(name: "chamnap") }
    let(:admin)   { Admin.create!(name: "chamnap") }
    let(:product) { Product.create!(name: "Laptop") }

    context "#liked_by?" do
      it "should receive #liked_by? on LikeModel" do
        Socialization::LikeModel.should_receive(:liked?).with(user, product)

        product.liked_by?(user)
      end

      it "raises exception when the LikeModel is not liker" do
        expect {
          product.liked_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likers" do
      it "should receive #likers on LikeModel" do
        Socialization::LikeModel.should_receive(:likers).with(product, User)

        product.likers(User)
      end
    end

    context "#likes_count" do
      it "returns total likes_count for all klasses" do
        user.like!(product)
        admin.like!(product)

        expect(product.likes_count).to eq(2)
      end

      it "returns total likes_count for a specific klass" do
        user.like!(product)
        admin.like!(product)

        expect(product.likes_count(User)).to eq(1)
        expect(product.likes_count(Admin)).to eq(1)
      end
    end

    context "#destroy" do
      it "removes like_models when this likeable is destroyed" do
        user.like!(product)
        expect(product.likers(User)).to eq([user])

        product.destroy
        expect(product.likers(User)).to eq([])
        expect(user.persisted?).to be_true
      end
    end
  end
end