class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Liker
  include Mongoid::Socialization::Follower
  include Mongoid::Socialization::Followable
  include Mongoid::Socialization::WishLister
  include Mongoid::Socialization::Conversationable
  include Mongoid::Socialization::Mentionable

  field           :name,                    type: String
  field           :after_mention_called,    type: Boolean, default: false
  field           :after_unmention_called,  type: Boolean, default: false

  after_mention    :after_mention_stub
  after_unmention  :after_unmention_stub

  private

    def after_mention_stub
      self.after_mention_called = true
    end

    def after_unmention_stub
      self.after_unmention_called = true
    end
end