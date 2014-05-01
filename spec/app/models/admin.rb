class Admin
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Liker
  include Mongoid::Follower
  include Mongoid::Followable
  include Mongoid::WishLister

  field   :name, type: String
end