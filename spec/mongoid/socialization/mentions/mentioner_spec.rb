require "spec_helper"

module Mongoid::Socialization
  describe Mentioner do
    let(:mention_klass) { Mongoid::Socialization.mention_klass }
    let(:user1)         { User.create!(name: "chamnap1") }
    let(:user2)         { User.create!(name: "chamnap2") }
    let(:product)       { Product.create!(name: "Laptop") }
    let(:comment)       { product.comments.create!(text: "@chamnap1, @chamnap2, let's check this out!") }

    context "#mention!" do
      it "should receive #mention! on Mention" do
        mention_klass.should_receive(:mention!).with(comment, user1)

        comment.mention!(user1)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.mention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#unmention!" do
      it "should receive #unmention! on Mention" do
        mention_klass.should_receive(:unmention!).with(comment, user1)

        comment.unmention!(user1)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.unmention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#toggle_mention!" do
      it "should receive #toggle_mention! on Mention" do
        mention_klass.should_receive(:toggle_mention!).with(comment, user1)

        comment.toggle_mention!(user1)
      end

      it "raises exception when it is not mentionable" do
        expect {
          comment.toggle_mention!(:foo)
        }.to raise_error(Mongoid::Socialization::Error)
      end
    end

    context "#mentioned?" do
      it "should receive #mentioned? on Mention" do
        mention_klass.should_receive(:mentioned?).with(comment, user1)

        comment.mentioned?(user1)
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

    context "#mentionables_count" do
      it "returns total mentionables_count for all klasses" do
        comment.mention!(user1)
        comment.mention!(user2)

        expect(comment.mentionables_count).to eq(2)
      end

      it "returns total mentionables_count for a specific klass" do
        comment.mention!(user1)
        comment.mention!(user2)

        expect(comment.mentionables_count(User)).to eq(2)
        expect(comment.mentionables_count(Admin)).to eq(0)
      end
    end

    context "#destroy" do
      it "removes mention_models when this mentioner is destroyed" do
        comment.mention!(user1)
        expect(comment.mentionables(User)).to eq([user1])

        comment.destroy
        expect(comment.mentionables(User)).to eq([])
        expect(product.persisted?).to be_true
      end
    end

    context "#update_mentionables_count!" do
      it "updates mentionables_count per klass" do
        comment.update_mentionables_count!(User, 1)

        comment.reload
        expect(comment.mentionables_count).to eq(1)
        expect(comment.mentionables_count(User)).to eq(1)
        expect(comment.mentionables_count(Admin)).to eq(0)
      end
    end
  end
end