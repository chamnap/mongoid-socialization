class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Likeable
  include Mongoid::Socialization::WishListable

  field       :name,      type: String

  has_many    :comments,  as: :product
end