require "spec_helper"

module Mongoid::Socialization
  describe WishListModel do
    let(:user1)    { User.create!(name: "chamnap1") }
    let(:user2)    { User.create!(name: "chamnap2") }
    let(:admin1)   { Admin.create!(name: "chamnap1") }
    let(:admin2)   { Admin.create!(name: "chamnap2") }
    let(:product1) { Product.create!(name: "Laptop1") }
    let(:product2) { Product.create!(name: "Laptop2") }
    let(:page1)    { Page.create!(name: "Page1") }
    let(:page2)    { Page.create!(name: "Page2") }

    context "#wish_list!" do
      it "returns true" do
        expect(WishListModel.wish_list!(user1, product1)).to be_true
      end

      it "returns false after wish_listed" do
        expect(WishListModel.wish_list!(user1, product1)).to be_true

        expect(WishListModel.wish_list!(user1, product1)).to be_false
      end

      it "increments #wish_lists_count" do
        WishListModel.wish_list!(user1, product1)
        expect(product1.wish_lists_count(User)).to eq(1)

        WishListModel.wish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(2)
      end

      it "pushs #wish_lister_ids" do
        WishListModel.wish_list!(user1, product1)
        expect(product1.wish_lister_ids(User).count).to eq(1)
        expect(product1.wish_lister_ids(User)).to include(user1.id)

        WishListModel.wish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(2)
        expect(product1.wish_lister_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not wish_lister" do
        expect {
          WishListModel.wish_list!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not wish_listable" do
        expect {
          WishListModel.wish_list!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unwish_list!" do
      it "returns true" do
        expect(WishListModel.wish_list!(user1, product1)).to be_true

        expect(WishListModel.unwish_list!(user1, product1)).to be_true
      end

      it "returns false after unwish_listed" do
        expect(WishListModel.unwish_list!(user1, product1)).to be_false
      end

      it "decrements #wish_lists_count" do
        WishListModel.wish_list!(user1, product1)
        WishListModel.wish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(2)

        WishListModel.unwish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(1)

        WishListModel.unwish_list!(user1, product1)
        expect(product1.wish_lists_count(User)).to eq(0)
      end

      it "pulls #wish_lister_ids" do
        WishListModel.wish_list!(user1, product1)
        WishListModel.wish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(2)

        WishListModel.unwish_list!(user1, product1)
        expect(product1.wish_lister_ids(User).count).to eq(1)
        expect(product1.wish_lister_ids(User)).to eq([user2.id])

        WishListModel.unwish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(0)
        expect(product1.wish_lister_ids(User)).to eq([])
      end

      it "raises exception when the actor is not wish_lister" do
        expect {
          WishListModel.unwish_list!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not wish_listable" do
        expect {
          WishListModel.unwish_list!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_wish_list!" do
      it "returns true after #wish_list!" do
        WishListModel.wish_list!(user1, product1)

        expect(WishListModel.toggle_wish_list!(user1, product1)).to be_true
        expect(WishListModel.wish_listed?(user1, product1)).to be_false
      end

      it "returns true after #unwish_list!" do
        WishListModel.unwish_list!(user1, product1)

        expect(WishListModel.toggle_wish_list!(user1, product1)).to be_true
        expect(WishListModel.wish_listed?(user1, product1)).to be_true
      end
    end

    context "#wish_listed?" do
      it "returns true after wish_listed" do
        WishListModel.wish_list!(user1, product1)

        expect(WishListModel.wish_listed?(user1, product1)).to be_true
      end

      it "returns false after unwish_list" do
        WishListModel.wish_list!(user1, product1)
        expect(WishListModel.wish_listed?(user1, product1)).to be_true

        WishListModel.unwish_list!(user1, product1)
        expect(WishListModel.wish_listed?(user1, product1)).to be_false
      end

      it "raises exception when it is not wish_listable" do
        expect {
          WishListModel.wish_listed?(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listables" do
      it "returns wish_listables objects by klass" do
        WishListModel.wish_list!(user1, product1)
        expect(WishListModel.wish_listables(user1, Product)).to eq([product1])

        WishListModel.wish_list!(user1, page1)
        expect(WishListModel.wish_listables(user1, Page)).to eq([page1])
      end

      it "returns []" do
        expect(WishListModel.wish_listables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not wish_listable" do
        expect {
          WishListModel.wish_listables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the wish_lister is not wish_lister" do
        expect {
          WishListModel.wish_listables(:foo, Product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listers" do
      it "returns wish_listers objects by klass" do
        WishListModel.wish_list!(user1, product1)
        WishListModel.wish_list!(user2, product1)

        WishListModel.wish_list!(admin1, product1)
        WishListModel.wish_list!(admin2, product1)

        expect(WishListModel.wish_listers(product1, User)).to eq([user1, user2])
        expect(WishListModel.wish_listers(product1, Admin)).to eq([admin1, admin2])
      end

      it "returns []" do
        expect(WishListModel.wish_listers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not wish_listable" do
        expect {
          WishListModel.wish_listers(product1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the wish_listable is not wish_listable" do
        expect {
          WishListModel.wish_listers(:foo, User)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end