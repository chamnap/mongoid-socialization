class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Liker
  include Mongoid::Follower
  include Mongoid::Followable
  include Mongoid::WishLister
  include Mongoid::Conversationable
  include Mongoid::Mentionable

  field           :name,                  type: String
end