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
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentioners" do
      it "should receive #mentioners on Mention" do
        mention_klass.should_receive(:mentioners).with(user, User)

        user.mentioners(User)
      end
    end

    context "#mentioners_count" do
      it "returns total mentioners_count for all klasses" do
        comment.mention!(user)
        comment.mention!(admin)

        expect(user.mentioners_count).to eq(1)
        expect(admin.mentioners_count).to eq(1)
      end

      it "returns total mentioners_count for a specific klass" do
        comment.mention!(user)
        comment.mention!(admin)

        expect(user.mentioners_count(Comment)).to eq(1)
        expect(admin.mentioners_count(Comment)).to eq(1)
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

    context "#update_mentioners_count!" do
      it "updates mentioners_count per klass" do
        user.update_mentioners_count!(Comment, 1)

        user.reload
        expect(user.mentioners_count).to eq(1)
        expect(user.mentioners_count(Comment)).to eq(1)
      end
    end

    context "callbacks" do
      it "invokes #after_mention callbacks" do
        expect(user.after_mention_called).to be_false

        comment.mention!(user)

        expect(user.after_mention_called).to be_true
        expect(user.mentioner).to eq(comment)
      end

      it "invokes #after_unmention callbacks" do
        comment.mention!(user)

        expect(user.after_mention_called).to be_true
        expect(user.after_unmention_called).to be_false

        comment.unmention!(user)

        expect(user.after_unmention_called).to be_true
        expect(user.unmentioner).to eq(comment)
      end
    end
  end
end