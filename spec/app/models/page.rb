class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Likeable
  include Mongoid::Socialization::Followable
  include Mongoid::Socialization::WishListable

  field       :name,      type: String

  has_many    :comments,  as: :page
end