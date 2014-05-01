class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Likeable
  include Mongoid::Followable
  include Mongoid::WishListable

  field   :name, type: String
end