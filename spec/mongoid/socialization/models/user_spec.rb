require "spec_helper"

describe User, type: :model do
  it { should have_field(:likeables_count).of_type(Hash).with_default_value_of({}) }
  it { should have_field(:followers_count).of_type(Hash).with_default_value_of({}) }
  it { should have_field(:followings_count).of_type(Hash).with_default_value_of({}) }
  it { should have_field(:wish_listables_count).of_type(Hash).with_default_value_of({}) }

  it { should have_and_belong_to_many(:conversations).of_type(Mongoid::Socialization.conversation_klass) }
end