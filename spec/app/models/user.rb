class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Liker

  field   :name, type: String
end