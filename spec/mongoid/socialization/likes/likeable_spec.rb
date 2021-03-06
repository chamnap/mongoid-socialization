require "spec_helper"

module Mongoid::Socialization
  describe Likeable do
    let(:like_klass) { Mongoid::Socialization.like_klass }
    let(:user)       { User.create!(name: "chamnap") }
    let(:admin)      { Admin.create!(name: "chamnap") }
    let(:product)    { Product.create!(name: "Laptop") }

    context "#liked_by?" do
      it "should receive #liked_by? on Like" do
        expect(like_klass).to receive(:liked?).with(user, product)

        product.liked_by?(user)
      end

      it "returns false when it is not liker" do
        expect(product.liked_by?(:foo)).to eq(false)
      end
    end

    context "#likers" do
      it "should receive #likers on Like" do
        expect(like_klass).to receive(:likers).with(product, User)

        product.likers(User)
      end
    end

    context "#likers_count" do
      it "returns total likers_count for all klasses" do
        user.like!(product)
        admin.like!(product)

        expect(product.likers_count).to eq(2)
      end

      it "returns total likers_count for a specific klass" do
        user.like!(product)
        admin.like!(product)

        expect(product.likers_count(User)).to eq(1)
        expect(product.likers_count(Admin)).to eq(1)
      end
    end

    context "#destroy" do
      it "removes like_models when this likeable is destroyed" do
        user.like!(product)
        expect(product.likers(User)).to eq([user])

        product.destroy
        expect(product.likers(User)).to eq([])
        expect(user.persisted?).to eq(true)
      end
    end

    context "#update_likers_count!" do
      it "updates likers_count per klass" do
        product.update_likers_count!(User, 1)
        product.update_likers_count!(Admin, 1)

        product.reload
        expect(product.likers_count).to eq(2)
        expect(product.likers_count(User)).to eq(1)
        expect(product.likers_count(Admin)).to eq(1)
      end
    end

    context "callbacks" do
      it "invokes #after_like callbacks" do
        expect(product.after_like_called).to eq(false)

        user.like!(product)

        expect(product.after_like_called).to eq(true)
        expect(product.liker).to eq(user)
      end

      it "invokes #after_unlike callbacks" do
        user.like!(product)

        expect(product.after_like_called).to eq(true)
        expect(product.after_unlike_called).to eq(false)

        user.unlike!(product)

        expect(product.after_unlike_called).to eq(true)
        expect(product.unliker).to eq(user)
      end
    end
  end
end