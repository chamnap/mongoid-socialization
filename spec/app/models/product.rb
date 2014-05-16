class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Socialization::Likeable
  include Mongoid::Socialization::WishListable

  field             :name,                     type: String
  field             :after_like_called,        type: Boolean, default: false
  field             :after_unlike_called,      type: Boolean, default: false
  field             :after_wish_list_called,   type: Boolean, default: false
  field             :after_unwish_list_called, type: Boolean, default: false

  has_many          :comments,                 as: :product

  after_like        :after_like_stub
  after_unlike      :after_unlike_stub
  after_wish_list   :after_wish_list_stub
  after_unwish_list :after_unwish_list_stub

  private

    def after_like_stub
      self.after_like_called = true
    end

    def after_unlike_stub
      self.after_unlike_called = true
    end

    def after_wish_list_stub
      self.after_wish_list_called = true
    end

    def after_unwish_list_stub
      self.after_unwish_list_called = true
    end
end