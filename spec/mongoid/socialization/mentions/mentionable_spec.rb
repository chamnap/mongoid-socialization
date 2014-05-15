require "spec_helper"

module Mongoid::Socialization
  describe Mentionable do
    let(:mention_klass) { Mongoid::Socialization.mention_klass }
    let(:user)          { User.create!(name: "chamnap") }
    let(:admin)         { Admin.create!(name: "chamnap") }
    let(:product)       { Product.create!(name: "Laptop") }
    let(:comment)       { product.comments.create!(text: "@chamnap, @admin, let's check this out!") }

    context "#mentioned_by?" do
      it "should receive #mentioned_by? on Mention" do
        mention_klass.should_receive(:mentioned?).with(comment, user)

        user.mentioned_by?(comment)
      end

      it "raises exception when the Mention is not mentioner" do
        expect {
          user.mentioned_by?(:foo)
        }.to raise_error(Mongoid::Socialization::ArgumentError)
      end
    end

    context "#mentioners" do
      it "should receive #mentioners on Mention" do
        mention_klass.should_receive(:mentioners).with(user, User)

        user.mentioners(User)
      end
    end

    context "#mentions_count" do
      it "returns total mentions_count for all klasses" do
        comment.mention!(user)
        comment.mention!(admin)

        expect(user.mentions_count).to eq(1)
        expect(admin.mentions_count).to eq(1)
      end

      it "returns total mentions_count for a specific klass" do
        comment.mention!(user)
        comment.mention!(admin)

        expect(user.mentions_count(Comment)).to eq(1)
        expect(admin.mentions_count(Comment)).to eq(1)
      end
    end

    context "#destroy" do
      it "removes mention_models when this mentionable is destroyed" do
        comment.mention!(user)
        expect(user.mentioners(Comment)).to eq([comment])

        user.destroy
        expect(user.mentioners(Comment)).to eq([])
        expect(comment.persisted?).to be_true
      end
    end
  end
end