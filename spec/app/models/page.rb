class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Likeable
  include Mongoid::Socialization::Followable
  include Mongoid::Socialization::WishListable

  field           :name,      type: String
  field           :after_follow_called,   type: Boolean, default: false
  field           :after_unfollow_called, type: Boolean, default: false

  has_many        :comments,              as: :page

  after_follow    :after_follow_stub
  after_unfollow  :after_unfollow_stub

  private

    def after_follow_stub
      self.after_follow_called = true
    end

    def after_unfollow_stub
      self.after_unfollow_called = true
    end
end