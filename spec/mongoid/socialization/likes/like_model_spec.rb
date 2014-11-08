require "spec_helper"

module Mongoid::Socialization
  describe LikeModel do
    let(:like_klass) { Mongoid::Socialization.like_klass }
    let(:user1)      { User.create!(name: "chamnap1") }
    let(:user2)      { User.create!(name: "chamnap2") }
    let(:admin1)     { Admin.create!(name: "chamnap1") }
    let(:admin2)     { Admin.create!(name: "chamnap2") }
    let(:product1)   { Product.create!(name: "Laptop1") }
    let(:product2)   { Product.create!(name: "Laptop2") }
    let(:page1)      { Page.create!(name: "Page1") }
    let(:page2)      { Page.create!(name: "Page2") }

    context "#like!" do
      it "returns true" do
        expect(like_klass.like!(user1, product1)).to be_true
      end

      it "returns false after liked" do
        expect(like_klass.like!(user1, product1)).to be_true

        expect(like_klass.like!(user1, product1)).to be_false
      end

      it "increments #likers_count" do
        like_klass.like!(user1, product1)
        expect(product1.likers_count(User)).to eq(1)

        like_klass.like!(user2, product1)
        expect(product1.likers_count(User)).to eq(2)
      end

      it "pushs #liker_ids" do
        like_klass.like!(user1, product1)
        expect(product1.liker_ids(User).count).to eq(1)
        expect(product1.liker_ids(User)).to include(user1.id)

        like_klass.like!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(2)
        expect(product1.liker_ids(User)).to include(user2.id)
      end

      it "raises exception when the actor is not liker" do
        expect {
          like_klass.like!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          like_klass.like!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unlike!" do
      it "returns true" do
        expect(like_klass.like!(user1, product1)).to be_true

        expect(like_klass.unlike!(user1, product1)).to be_true
      end

      it "returns false after unliked" do
        expect(like_klass.unlike!(user1, product1)).to be_false
      end

      it "decrements #likers_count" do
        like_klass.like!(user1, product1)
        like_klass.like!(user2, product1)
        product1.reload
        expect(product1.likers_count(User)).to eq(2)

        like_klass.unlike!(user2, product1)
        product1.reload
        expect(product1.likers_count(User)).to eq(1)

        like_klass.unlike!(user1, product1)
        product1.reload
        expect(product1.likers_count(User)).to eq(0)
      end

      it "pulls #liker_ids" do
        like_klass.like!(user1, product1)
        like_klass.like!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(2)

        like_klass.unlike!(user1, product1)
        expect(product1.liker_ids(User).count).to eq(1)
        expect(product1.liker_ids(User)).to eq([user2.id])

        like_klass.unlike!(user2, product1)
        expect(product1.liker_ids(User).count).to eq(0)
        expect(product1.liker_ids(User)).to eq([])
      end

      it "raises exception when the actor is not liker" do
        expect {
          like_klass.unlike!(:foo, product1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not likeable" do
        expect {
          like_klass.unlike!(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_like!" do
      it "returns true after #like!" do
        like_klass.like!(user1, product1)

        expect(like_klass.toggle_like!(user1, product1)).to be_true
        expect(like_klass.liked?(user1, product1)).to be_false
      end

      it "returns true after #unlike!" do
        like_klass.unlike!(user1, product1)

        expect(like_klass.toggle_like!(user1, product1)).to be_true
        expect(like_klass.liked?(user1, product1)).to be_true
      end
    end

    context "#liked?" do
      it "returns true after liked" do
        like_klass.like!(user1, product1)

        expect(like_klass.liked?(user1, product1)).to be_true
      end

      it "returns false after unlike" do
        like_klass.like!(user1, product1)
        expect(like_klass.liked?(user1, product1)).to be_true

        like_klass.unlike!(user1, product1)
        expect(like_klass.liked?(user1, product1)).to be_false
      end

      it "raises exception when it is not likeable" do
        expect {
          like_klass.liked?(:foo, product1)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#likeables" do
      it "returns likeables objects by klass" do
        like_klass.like!(user1, product1)
        expect(like_klass.likeables(user1, Product)).to eq([product1])

        like_klass.like!(user1, page1)
        expect(like_klass.likeables(user1, Page)).to eq([page1])
      end

      it "returns []" do
        expect(like_klass.likeables(user2, Page)).to eq([])
      end

      it "raises exception when the klass is not likeable" do
        expect {
          like_klass.likeables(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the liker is not liker" do
        expect {
          like_klass.likeables(:foo, Product)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#likers" do
      it "returns likers objects by klass" do
        like_klass.like!(user1, product1)
        like_klass.like!(user2, product1)

        like_klass.like!(admin1, product1)
        like_klass.like!(admin2, product1)

        expect(like_klass.likers(product1, User)).to eq([user1, user2])
        expect(like_klass.likers(product1, Admin).to_a.sort).to eq([admin1, admin2].sort)
      end

      it "returns []" do
        expect(like_klass.likers(page1, Admin)).to eq([])
      end

      it "raises exception when the klass is not likeable" do
        expect {
          like_klass.likers(product1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the likeable is not likeable" do
        expect {
          like_klass.likers(:foo, User)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end
  end
end