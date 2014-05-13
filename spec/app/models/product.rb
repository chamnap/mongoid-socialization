class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Likeable
  include Mongoid::WishListable

  field       :name,      type: String

  has_many    :comments,  as: :product
end