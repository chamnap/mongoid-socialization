require "spec_helper"

module Mongoid
  describe Liker do
    let(:user)    { User.create!(name: "chamnap") }
    let(:product) { Product.create!(name: "Laptop") }

    context "#wish_list!" do
      it "should receive #wish_list! on WishListModel" do
        Socialization::WishListModel.should_receive(:wish_list!).with(user, product)

        user.wish_list!(product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unwish_list!" do
      it "should receive #unwish_list! on WishListModel" do
        Socialization::WishListModel.should_receive(:unwish_list!).with(user, product)

        user.unwish_list!(product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.unwish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_wish_list!" do
      it "should receive #toggle_wish_list! on WishListModel" do
        Socialization::WishListModel.should_receive(:toggle_wish_list!).with(user, product)

        user.toggle_wish_list!(product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.toggle_wish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listed?" do
      it "should receive #wish_listed? on WishListModel" do
        Socialization::WishListModel.should_receive(:wish_listed?).with(user, product)

        user.wish_listed?(product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_listed?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listables" do
      it "should receive #wish_listables on WishListModel" do
        Socialization::WishListModel.should_receive(:wish_listables).with(user, Product)

        user.wish_listables(Product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_listables(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#destroy" do
      it "removes wish_list_models when this wish_listr is destroyed" do
        user.wish_list!(product)
        expect(user.wish_listables(Product)).to eq([product])

        user.destroy
        expect(user.wish_listables(Product)).to eq([])
        expect(product.persisted?).to be_true
      end
    end
  end
end