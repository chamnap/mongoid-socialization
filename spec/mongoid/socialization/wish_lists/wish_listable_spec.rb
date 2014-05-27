require "spec_helper"

module Mongoid::Socialization
  describe WishListable do
    let(:wish_list_klass) { Mongoid::Socialization.wish_list_klass }
    let(:user)            { User.create!(name: "chamnap") }
    let(:admin)           { Admin.create!(name: "chamnap") }
    let(:product)         { Product.create!(name: "Laptop") }

    context "#wish_listed_by?" do
      it "should receive #wish_listed_by? on WishListModel" do
        wish_list_klass.should_receive(:wish_listed?).with(user, product)

        product.wish_listed_by?(user)
      end

      it "raises exception when the WishListModel is not wish_listr" do
        expect {
          product.wish_listed_by?(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#wish_listers" do
      it "should receive #wish_listers on WishListModel" do
        wish_list_klass.should_receive(:wish_listers).with(product, User)

        product.wish_listers(User)
      end
    end

    context "#wish_listers_count" do
      it "returns total wish_listers_count for all klasses" do
        user.wish_list!(product)
        admin.wish_list!(product)

        expect(product.wish_listers_count).to eq(2)
      end

      it "returns total wish_listers_count for a specific klass" do
        user.wish_list!(product)
        admin.wish_list!(product)

        expect(product.wish_listers_count(User)).to eq(1)
        expect(product.wish_listers_count(Admin)).to eq(1)
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

    context "#update_wish_listers_count!" do
      it "updates wish_listers_count per klass" do
        product.update_wish_listers_count!(User, 1)
        product.update_wish_listers_count!(Admin, 1)

        product.reload
        expect(product.wish_listers_count).to eq(2)
        expect(product.wish_listers_count(User)).to eq(1)
        expect(product.wish_listers_count(Admin)).to eq(1)
      end
    end

    context "callbacks" do
      it "invokes #after_wish_list callbacks" do
        expect(product.after_wish_list_called).to be_false

        user.wish_list!(product)

        expect(product.after_wish_list_called).to be_true
        expect(product.wish_lister).to eq(user)
      end

      it "invokes #after_unwish_list callbacks" do
        user.wish_list!(product)

        expect(product.after_wish_list_called).to be_true
        expect(product.after_unwish_list_called).to be_false

        user.unwish_list!(product)

        expect(product.after_unwish_list_called).to be_true
        expect(product.unwish_lister).to eq(user)
      end
    end
  end
end