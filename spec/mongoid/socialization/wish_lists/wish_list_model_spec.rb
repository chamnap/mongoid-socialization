require "spec_helper"

module Mongoid::Socialization
  describe WishListModel do
    let(:wish_list_klass) { Mongoid::Socialization.wish_list_klass }
    let(:user1)           { User.create!(name: "chamnap1") }
    let(:user2)           { User.create!(name: "chamnap2") }
    let(:admin1)          { Admin.create!(name: "chamnap1") }
    let(:admin2)          { Admin.create!(name: "chamnap2") }
    let(:product1)        { Product.create!(name: "Laptop1") }
    let(:product2)        { Product.create!(name: "Laptop2") }
    let(:page1)           { Page.create!(name: "Page1") }
    let(:page2)           { Page.create!(name: "Page2") }

    context "#wish_list!" do
      it "returns true" do
        expect(wish_list_klass.wish_list!(user1, product1)).to be_true
      end

      it "returns false after wish_listed" do
        expect(wish_list_klass.wish_list!(user1, product1)).to be_true

        expect(wish_list_klass.wish_list!(user1, product1)).to be_false
      end

      it "increments #wish_lists_count" do
        wish_list_klass.wish_list!(user1, product1)
        expect(product1.wish_lists_count(User)).to eq(1)

        wish_list_klass.wish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(2)
      end

      it "pushs #wish_lister_ids" do
        wish_list_klass.wish_list!(user1, product1)
        expect(product1.wish_lister_ids(User).count).to eq(1)
        expect(product1.wish_lister_ids(User)).to include(user1.id)

        wish_list_klass.wish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(2)
        expect(product1.wish_lister_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not wish_lister" do
        expect {
          wish_list_klass.wish_list!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not wish_listable" do
        expect {
          wish_list_klass.wish_list!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#unwish_list!" do
      it "returns true" do
        expect(wish_list_klass.wish_list!(user1, product1)).to be_true

        expect(wish_list_klass.unwish_list!(user1, product1)).to be_true
      end

      it "returns false after unwish_listed" do
        expect(wish_list_klass.unwish_list!(user1, product1)).to be_false
      end

      it "decrements #wish_lists_count" do
        wish_list_klass.wish_list!(user1, product1)
        wish_list_klass.wish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(2)

        wish_list_klass.unwish_list!(user2, product1)
        expect(product1.wish_lists_count(User)).to eq(1)

        wish_list_klass.unwish_list!(user1, product1)
        expect(product1.wish_lists_count(User)).to eq(0)
      end

      it "pulls #wish_lister_ids" do
        wish_list_klass.wish_list!(user1, product1)
        wish_list_klass.wish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(2)

        wish_list_klass.unwish_list!(user1, product1)
        expect(product1.wish_lister_ids(User).count).to eq(1)
        expect(product1.wish_lister_ids(User)).to eq([user2.id])

        wish_list_klass.unwish_list!(user2, product1)
        expect(product1.wish_lister_ids(User).count).to eq(0)
        expect(product1.wish_lister_ids(User)).to eq([])
      end

      it "raises exception when the actor is not wish_lister" do
        expect {
          wish_list_klass.unwish_list!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the victim is not wish_listable" do
        expect {
          wish_list_klass.unwish_list!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#toggle_wish_list!" do
      it "returns true after #wish_list!" do
        wish_list_klass.wish_list!(user1, product1)

        expect(wish_list_klass.toggle_wish_list!(user1, product1)).to be_true
        expect(wish_list_klass.wish_listed?(user1, product1)).to be_false
      end

      it "returns true after #unwish_list!" do
        wish_list_klass.unwish_list!(user1, product1)

        expect(wish_list_klass.toggle_wish_list!(user1, product1)).to be_true
        expect(wish_list_klass.wish_listed?(user1, product1)).to be_true
      end
    end

    context "#wish_listed?" do
      it "returns true after wish_listed" do
        wish_list_klass.wish_list!(user1, product1)

        expect(wish_list_klass.wish_listed?(user1, product1)).to be_true
      end

      it "returns false after unwish_list" do
        wish_list_klass.wish_list!(user1, product1)
        expect(wish_list_klass.wish_listed?(user1, product1)).to be_true

        wish_list_klass.unwish_list!(user1, product1)
        expect(wish_list_klass.wish_listed?(user1, product1)).to be_false
      end

      it "raises exception when it is not wish_listable" do
        expect {
          wish_list_klass.wish_listed?(:foo, product1)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listables" do
      it "returns wish_listables objects by klass" do
        wish_list_klass.wish_list!(user1, product1)
        expect(wish_list_klass.wish_listables(user1, Product)).to eq([product1])

        wish_list_klass.wish_list!(user1, page1)
        expect(wish_list_klass.wish_listables(user1, Page)).to eq([page1])
      end

      it "returns []" do
        expect(wish_list_klass.wish_listables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not wish_listable" do
        expect {
          wish_list_klass.wish_listables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the wish_lister is not wish_lister" do
        expect {
          wish_list_klass.wish_listables(:foo, Product)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#wish_listers" do
      it "returns wish_listers objects by klass" do
        wish_list_klass.wish_list!(user1, product1)
        wish_list_klass.wish_list!(user2, product1)

        wish_list_klass.wish_list!(admin1, product1)
        wish_list_klass.wish_list!(admin2, product1)

        expect(wish_list_klass.wish_listers(product1, User)).to eq([user1, user2])
        expect(wish_list_klass.wish_listers(product1, Admin)).to eq([admin1, admin2])
      end

      it "returns []" do
        expect(wish_list_klass.wish_listers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not wish_listable" do
        expect {
          wish_list_klass.wish_listers(product1, :foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end

      it "raises exception when the wish_listable is not wish_listable" do
        expect {
          wish_list_klass.wish_listers(:foo, User)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end
  end
end