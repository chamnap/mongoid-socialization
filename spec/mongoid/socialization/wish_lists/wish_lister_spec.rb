require "spec_helper"

module Mongoid::Socialization
  describe WishLister do
    let(:wish_list_klass) { Mongoid::Socialization.wish_list_klass }
    let(:user)            { User.create!(name: "chamnap") }
    let(:product1)        { Product.create!(name: "product1") }
    let(:product2)        { Product.create!(name: "product2") }
    let(:page1)           { Page.create!(name: "page1") }
    let(:page2)           { Page.create!(name: "page2") }

    context "#wish_list!" do
      it "should receive #wish_list! on WishListModel" do
        wish_list_klass.should_receive(:wish_list!).with(user, product1)

        user.wish_list!(product1)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unwish_list!" do
      it "should receive #unwish_list! on WishListModel" do
        wish_list_klass.should_receive(:unwish_list!).with(user, product1)

        user.unwish_list!(product1)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.unwish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_wish_list!" do
      it "should receive #toggle_wish_list! on WishListModel" do
        wish_list_klass.should_receive(:toggle_wish_list!).with(user, product1)

        user.toggle_wish_list!(product1)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.toggle_wish_list!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#wish_listed?" do
      it "should receive #wish_listed? on WishListModel" do
        wish_list_klass.should_receive(:wish_listed?).with(user, product1)

        user.wish_listed?(product1)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_listed?(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#wish_listables" do
      it "should receive #wish_listables on WishListModel" do
        wish_list_klass.should_receive(:wish_listables).with(user, Product)

        user.wish_listables(Product)
      end

      it "raises exception when it is not wish_listable" do
        expect {
          user.wish_listables(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#wish_listables_count" do
      it "returns total wish_listables_count for all klasses" do
        user.wish_list!(product1)
        user.wish_list!(product2)

        expect(user.wish_listables_count).to eq(2)
      end

      it "returns total wish_listables_count for a specific klass" do
        user.wish_list!(product1)
        user.wish_list!(product2)

        user.wish_list!(page1)
        user.wish_list!(page2)

        expect(user.wish_listables_count(Page)).to eq(2)
        expect(user.wish_listables_count(Product)).to eq(2)
      end
    end

    context "#destroy" do
      it "removes wish_list_models when this wish_listr is destroyed" do
        user.wish_list!(product1)
        expect(user.wish_listables(Product)).to eq([product1])

        user.destroy
        expect(user.wish_listables(Product)).to eq([])
        expect(product1.persisted?).to be_true
      end
    end

    context "#update_wish_listables_count!" do
      it "updates wish_listables_count per klass" do
        user.update_wish_listables_count!(Page, 1)
        user.update_wish_listables_count!(Product, 1)

        user.reload
        expect(user.wish_listables_count).to eq(2)
        expect(user.wish_listables_count(Page)).to eq(1)
        expect(user.wish_listables_count(Product)).to eq(1)
      end
    end
  end
end