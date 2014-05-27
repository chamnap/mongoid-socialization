require "spec_helper"

describe Comment, type: :model do
  it { should have_field(:mentionables_count).of_type(Hash).with_default_value_of({}) }
  it { should have_field(:text).of_type(String) }
  it { should belong_to(:product).of_type(Product) }
  it { should belong_to(:page).of_type(Page) }
  it { should belong_to(:commenter).of_type(User) }
end