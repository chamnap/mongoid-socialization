require "spec_helper"

module Mongoid::Socialization
  describe Liker do
    let(:like_klass) { Mongoid::Socialization.like_klass }
    let(:user)       { User.create!(name: "chamnap") }
    let(:product)    { Product.create!(name: "Laptop") }

    context "#like!" do
      it "should receive #like! on Like" do
        like_klass.should_receive(:like!).with(user, product)

        user.like!(product)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.like!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unlike!" do
      it "should receive #unlike! on Like" do
        like_klass.should_receive(:unlike!).with(user, product)

        user.unlike!(product)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.unlike!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_like!" do
      it "should receive #toggle_like! on Like" do
        like_klass.should_receive(:toggle_like!).with(user, product)

        user.toggle_like!(product)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.toggle_like!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#liked?" do
      it "should receive #liked? on Like" do
        like_klass.should_receive(:liked?).with(user, product)

        user.liked?(product)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.liked?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#likeables" do
      it "should receive #likeables on Like" do
        like_klass.should_receive(:likeables).with(user, Product)

        user.likeables(Product)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.likeables(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#destroy" do
      it "removes like_models when this liker is destroyed" do
        user.like!(product)
        expect(user.likeables(Product)).to eq([product])

        user.destroy
        expect(user.likeables(Product)).to eq([])
        expect(product.persisted?).to be_true
      end
    end
  end
end