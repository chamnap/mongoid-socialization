require "spec_helper"

describe Product, type: :model do
  it { should have_field(:wish_lists_count).of_type(Hash).with_default_value_of({}) }
end

module Mongoid
  describe WishListable do
    let(:user)    { User.create!(name: "chamnap") }
    let(:admin)   { Admin.create!(name: "chamnap") }
    let(:product) { Product.create!(name: "Laptop") }

    context "#wish_listed_by?" do
      it "should receive #wish_listed_by? on WishListModel" do
        Socialization::WishListModel.should_receive(:wish_listed?).with(user, product)

        product.wish_listed_by?(user)
      end

      it "raises exception when the WishListModel is not wish_listr" do
        expect {
          product.wish_listed_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listers" do
      it "should receive #wish_listers on WishListModel" do
        Socialization::WishListModel.should_receive(:wish_listers).with(product, User)

        product.wish_listers(User)
      end
    end

    context "#wish_lists_count" do
      it "returns total wish_lists_count for all klasses" do
        user.wish_list!(product)
        admin.wish_list!(product)

        expect(product.wish_lists_count).to eq(2)
      end

      it "returns total wish_lists_count for a specific klass" do
        user.wish_list!(product)
        admin.wish_list!(product)

        expect(product.wish_lists_count(User)).to eq(1)
        expect(product.wish_lists_count(Admin)).to eq(1)
      end
    end

    context "#destroy" do
      it "removes wish_list_models when this wish_listable is destroyed" do
        user.wish_list!(product)
        expect(product.wish_listers(User)).to eq([user])

        product.destroy
        expect(product.wish_listers(User)).to eq([])
        expect(user.persisted?).to be_true
      end
    end
  end
end