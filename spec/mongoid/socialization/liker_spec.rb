require "spec_helper"

describe Mongoid::Liker do
  let(:user)    { User.create!(name: "chamnap") }
  let(:product) { Product.create!(name: "Laptop") }

  context "#like!" do
    it "should receive #like! on victim" do
      product.should_receive(:like!).with(user)

      user.like!(product)
    end

    it "raises exception when the victim is not likeable" do
      expect {
        user.like!(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end

  context "#unlike!" do
    it "should receive #unlike! on victim" do
      product.should_receive(:unlike!).with(user)

      user.unlike!(product)
    end

    it "raises exception when the victim is not likeable" do
      expect {
        user.unlike!(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end

  context "#liked?" do
    it "should receive #liked? on victim" do
      product.should_receive(:liked_by?).with(user)

      user.liked?(product)
    end

    it "raises exception when the victim is not likeable" do
      expect {
        user.liked?(:foo)
      }.to raise_error(Mongoid::Socialization::ArgumentError)
    end
  end
end