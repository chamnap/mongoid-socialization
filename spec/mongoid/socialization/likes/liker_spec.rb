require "spec_helper"

module Mongoid::Socialization
  describe Liker do
    let(:like_klass) { Mongoid::Socialization.like_klass }
    let(:user)       { User.create!(name: "chamnap") }
    let(:product1)   { Product.create!(name: "product1") }
    let(:product2)   { Product.create!(name: "product2") }
    let(:page1)      { Page.create!(name: "page1") }
    let(:page2)      { Page.create!(name: "page2") }

    context "#like!" do
      it "should receive #like! on Like" do
        like_klass.should_receive(:like!).with(user, product1)

        user.like!(product1)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.like!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unlike!" do
      it "should receive #unlike! on Like" do
        like_klass.should_receive(:unlike!).with(user, product1)

        user.unlike!(product1)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.unlike!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_like!" do
      it "should receive #toggle_like! on Like" do
        like_klass.should_receive(:toggle_like!).with(user, product1)

        user.toggle_like!(product1)
      end

      it "raises exception when it is not likeable" do
        expect {
          user.toggle_like!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#liked?" do
      it "should receive #liked? on Like" do
        like_klass.should_receive(:liked?).with(user, product1)

        user.liked?(product1)
      end

      it "returns false when it is not likeable" do
        expect(user.liked?(:foo)).to be_false
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
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#likeables_count" do
      it "returns total likeables_count for all klasses" do
        user.like!(product1)
        user.like!(product2)

        expect(user.likeables_count).to eq(2)
      end

      it "returns total likeables_count for a specific klass" do
        user.like!(product1)
        user.like!(product2)

        user.like!(page1)
        user.like!(page2)

        expect(user.likeables_count(Page)).to eq(2)
        expect(user.likeables_count(Product)).to eq(2)
      end
    end

    context "#destroy" do
      it "removes like_models when this liker is destroyed" do
        user.like!(product1)
        expect(user.likeables(Product)).to eq([product1])

        user.destroy
        expect(user.likeables(Product)).to eq([])
        expect(product1.persisted?).to be_true
      end
    end

    context "#update_likeables_count!" do
      it "updates likeables_count per klass" do
        user.update_likeables_count!(Page, 1)
        user.update_likeables_count!(Product, 1)

        user.reload
        expect(user.likeables_count).to eq(2)
        expect(user.likeables_count(Page)).to eq(1)
        expect(user.likeables_count(Product)).to eq(1)
      end
    end
  end
end