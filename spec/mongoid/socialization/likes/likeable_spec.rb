require "spec_helper"

describe Product, type: :model do
  it { should have_field(:likes_count).of_type(Hash).with_default_value_of({}) }
end

module Mongoid
  describe Likeable do
    let(:user)    { User.create!(name: "chamnap") }
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
  end
end