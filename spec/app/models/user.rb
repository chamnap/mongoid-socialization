class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Liker
  include Mongoid::Socialization::Follower
  include Mongoid::Socialization::Followable
  include Mongoid::Socialization::WishLister
  include Mongoid::Socialization::Conversationable
  include Mongoid::Socialization::Mentionable

  field           :name,                  type: String
end