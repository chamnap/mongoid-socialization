require "spec_helper"

module Mongoid::Socialization
  describe Mentioner do
    let(:mention_klass) { Mongoid::Socialization.mention_klass }
    let(:user)          { User.create!(name: "chamnap") }
    let(:product)       { Product.create!(name: "Laptop") }
    let(:comment)       { product.comments.create!(text: "@chamnap, @admin, let's check this out!") }

    context "#mention!" do
      it "should receive #mention! on Mention" do
        mention_klass.should_receive(:mention!).with(comment, user)

        comment.mention!(user)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.mention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unmention!" do
      it "should receive #unmention! on Mention" do
        mention_klass.should_receive(:unmention!).with(comment, user)

        comment.unmention!(user)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.unmention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_mention!" do
      it "should receive #toggle_mention! on Mention" do
        mention_klass.should_receive(:toggle_mention!).with(comment, user)

        comment.toggle_mention!(user)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.toggle_mention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentioned?" do
      it "should receive #mentioned? on Mention" do
        mention_klass.should_receive(:mentioned?).with(comment, user)

        comment.mentioned?(user)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.mentioned?(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentionables" do
      it "should receive #mentionables on Mention" do
        mention_klass.should_receive(:mentionables).with(comment, User)

        comment.mentionables(User)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.mentionables(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#destroy" do
      it "removes mention_models when this mentioner is destroyed" do
        comment.mention!(user)
        expect(comment.mentionables(User)).to eq([user])

        comment.destroy
        expect(comment.mentionables(User)).to eq([])
        expect(product.persisted?).to be_true
      end
    end
  end
end