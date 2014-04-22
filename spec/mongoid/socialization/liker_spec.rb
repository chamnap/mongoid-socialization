require "spec_helper"

describe User, type: :model do
  it { should have_field(:likeable_klasses).of_type(Array).with_default_value_of([]) }
end

module Mongoid
  describe Liker do
    let(:user)    { User.create!(name: "chamnap") }
    let(:product) { Product.create!(name: "Laptop") }

    context "#like!" do
      it "should receive #like! on Likes" do
        Socialization::Likes.should_receive(:like!).with(user, product)

        user.like!(product)
      end

      it "raises exception when the Likes is not likeable" do
        expect {
          user.like!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unlike!" do
      it "should receive #unlike! on Likes" do
        Socialization::Likes.should_receive(:unlike!).with(user, product)

        user.unlike!(product)
      end

      it "raises exception when the Likes is not likeable" do
        expect {
          user.unlike!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_like!" do
      it "should receive #toggle_like! on Likes" do
        Socialization::Likes.should_receive(:toggle_like!).with(user, product)

        user.toggle_like!(product)
      end

      it "raises exception when the Likes is not likeable" do
        expect {
          user.toggle_like!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#liked?" do
      it "should receive #liked? on Likes" do
        Socialization::Likes.should_receive(:liked?).with(user, product)

        user.liked?(product)
      end

      it "raises exception when the Likes is not likeable" do
        expect {
          user.liked?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likeables" do
      it "should receive #likeables on Likes" do
        Socialization::Likes.should_receive(:likeables).with(user, Product)

        user.likeables(Product)
      end

      it "raises exception when the Likes is not likeable" do
        expect {
          user.likeables(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end