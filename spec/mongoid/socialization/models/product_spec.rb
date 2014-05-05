require "spec_helper"

describe Product, type: :model do
  it { should have_field(:likes_count).of_type(Hash).with_default_value_of({}) }
end