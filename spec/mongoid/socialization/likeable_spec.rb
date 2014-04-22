require "spec_helper"

describe Product, type: :model do
  it { should have_field(:likes_count).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:liker_ids).of_type(Array).with_default_value_of([]) }
end

module Mongoid
  describe Likeable do
    let(:user)    { User.create!(name: "chamnap") }
    let(:product) { Product.create!(name: "Laptop") }

    context "#liked_by?" do
      it "should receive #liked_by? on Likes" do
        Socialization::Likes.should_receive(:liked?).with(user, product)

        product.liked_by?(user)
      end

      it "raises exception when the Likes is not liker" do
        expect {
          product.liked_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likers" do
      it "should receive #likers on Likes" do
        Socialization::Likes.should_receive(:likers).with(product)

        product.likers
      end
    end
  end
end