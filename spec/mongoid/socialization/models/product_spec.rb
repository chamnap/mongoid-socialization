require "spec_helper"

describe Product, type: :model do
  it { should have_field(:likes_count).of_type(Hash).with_default_value_of({}) }
  it { should have_field(:wish_lists_count).of_type(Hash).with_default_value_of({}) }
end