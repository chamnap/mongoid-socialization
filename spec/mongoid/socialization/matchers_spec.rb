require "spec_helper"

describe Admin do
  it { should be_a_liker }
  it { should be_a_follower }
  it { should be_a_followable }
  it { should be_a_wish_lister }
  it { should be_a_mentionable }
end

describe Comment do
  it { should be_a_mentioner }
end

describe Page do
  it { should be_a_likeable }
  it { should be_a_followable }
  it { should be_a_wish_listable }
end

describe Product do
  it { should be_a_likeable }
  it { should be_a_wish_listable }
end

describe User do
  it { should be_a_liker }
  it { should be_a_follower }
  it { should be_a_followable }
  it { should be_a_wish_lister }
  it { should be_a_mentionable }
end