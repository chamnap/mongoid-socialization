class Admin
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Liker
  include Mongoid::Follower
  include Mongoid::Followable

  field   :name, type: String
end