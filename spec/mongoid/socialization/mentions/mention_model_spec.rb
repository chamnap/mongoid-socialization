require "spec_helper"

module Mongoid::Socialization
  describe MentionModel do
    let(:mention_klass) { Mongoid::Socialization.mention_klass }
    let(:user1)         { User.create!(name: "chamnap1") }
    let(:user2)         { User.create!(name: "chamnap2") }
    let(:admin1)        { Admin.create!(name: "chamnap1") }
    let(:admin2)        { Admin.create!(name: "chamnap2") }
    let(:product1)      { Product.create!(name: "Laptop1") }
    let(:product2)      { Product.create!(name: "Laptop2") }
    let(:page1)         { Page.create!(name: "Page1") }
    let(:page2)         { Page.create!(name: "Page2") }
    let(:comment1)      { product1.comments.create!(text: "@chamnap1, @admin1, let's check this out!") }
    let(:comment2)      { product1.comments.create!(text: "@chamnap1, @admin2, this one looks cool.") }

    context "#mention!" do
      it "returns true" do
        expect(mention_klass.mention!(comment1, user1)).to be_true
      end

      it "returns false after mentioned" do
        expect(mention_klass.mention!(comment1, user1)).to be_true

        expect(mention_klass.mention!(comment1, user1)).to be_false
      end

      it "increments #mentions_count" do
        mention_klass.mention!(comment1, user1)
        expect(user1.mentions_count(Comment)).to eq(1)

        mention_klass.mention!(comment2, user1)
        expect(user1.mentions_count(Comment)).to eq(2)
      end

      it "pushs #mentioner_ids" do
        mention_klass.mention!(comment1, user1)
        expect(user1.mentioner_ids(Comment).count).to eq(1)
        expect(user1.mentioner_ids(Comment)).to include(comment1.id)

        mention_klass.mention!(comment2, user1)
        expect(user1.mentioner_ids(Comment).count).to eq(2)
        expect(user1.mentioner_ids(Comment)).to include(comment2.id)
      end

      it "raises exception when the actor is not mentioner" do
        expect {
          mention_klass.mention!(:foo, user1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not mentionable" do
        expect {
          mention_klass.mention!(comment1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unmention!" do
      it "returns true" do
        expect(mention_klass.mention!(comment1, user1)).to be_true

        expect(mention_klass.unmention!(comment1, user1)).to be_true
      end

      it "returns false after unmentioned" do
        expect(mention_klass.unmention!(comment1, user1)).to be_false
      end

      it "decrements #mentions_count" do
        mention_klass.mention!(comment1, user1)
        mention_klass.mention!(comment2, user1)
        expect(user1.mentions_count(Comment)).to eq(2)

        mention_klass.unmention!(comment2, user1)
        expect(user1.mentions_count(Comment)).to eq(1)

        mention_klass.unmention!(comment1, user1)
        expect(user1.mentions_count(Comment)).to eq(0)
      end

      it "pulls #mentioner_ids" do
        mention_klass.mention!(comment1, user1)
        mention_klass.mention!(comment2, user1)
        expect(user1.mentioner_ids(Comment).count).to eq(2)

        mention_klass.unmention!(comment1, user1)
        expect(user1.mentioner_ids(Comment).count).to eq(1)
        expect(user1.mentioner_ids(Comment)).to eq([comment2.id])

        mention_klass.unmention!(comment2, user1)
        expect(user1.mentioner_ids(Comment).count).to eq(0)
        expect(user1.mentioner_ids(Comment)).to eq([])
      end

      it "raises exception when the actor is not mentioner" do
        expect {
          mention_klass.unmention!(:foo, user1)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the victim is not mentionable" do
        expect {
          mention_klass.unmention!(comment1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_mention!" do
      it "returns true after #mention!" do
        mention_klass.mention!(comment1, user1)

        expect(mention_klass.toggle_mention!(comment1, user1)).to be_true
        expect(mention_klass.mentioned?(comment1, user1)).to be_false
      end

      it "returns true after #unmention!" do
        mention_klass.unmention!(comment1, user1)

        expect(mention_klass.toggle_mention!(comment1, user1)).to be_true
        expect(mention_klass.mentioned?(comment1, user1)).to be_true
      end
    end

    context "#mentioned?" do
      it "returns true after mentioned" do
        mention_klass.mention!(comment1, user1)

        expect(mention_klass.mentioned?(comment1, user1)).to be_true
      end

      it "returns false after unmention" do
        mention_klass.mention!(comment1, user1)
        expect(mention_klass.mentioned?(comment1, user1)).to be_true

        mention_klass.unmention!(comment1, user1)
        expect(mention_klass.mentioned?(comment1, user1)).to be_false
      end

      it "raises exception when it is not mentionable" do
        expect {
          mention_klass.mentioned?(:foo, user1)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentionables" do
      it "returns mentionables objects by klass" do
        mention_klass.mention!(comment1, user1)
        expect(mention_klass.mentionables(comment1, User)).to eq([user1])

        mention_klass.mention!(comment1, admin1)
        expect(mention_klass.mentionables(comment1, Admin)).to eq([admin1])
      end

      it "returns []" do
        expect(mention_klass.mentionables(comment2, User)).to eq([])
      end

      it "raises exception when the klass is not mentionable" do
        expect {
          mention_klass.mentionables(comment1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the mentioner is not mentioner" do
        expect {
          mention_klass.mentionables(:foo, User)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentioners" do
      it "returns mentioners objects by klass" do
        mention_klass.mention!(comment1, user1)
        mention_klass.mention!(comment1, admin1)

        mention_klass.mention!(comment2, user1)
        mention_klass.mention!(comment2, admin1)

        expect(mention_klass.mentioners(user1, Comment)).to eq([comment1, comment2])
        expect(mention_klass.mentioners(admin1, Comment)).to eq([comment1, comment2])
      end

      it "returns []" do
        expect(mention_klass.mentioners(user1, Comment)).to eq([])
      end

      it "raises exception when the klass is not mentionable" do
        expect {
          mention_klass.mentioners(user1, :foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end

      it "raises exception when the mentionable is not mentionable" do
        expect {
          mention_klass.mentioners(:foo, Comment)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end
  end
end