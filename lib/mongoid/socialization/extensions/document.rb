module Mongoid
  module Document

    def likeable?
      self.class.included_modules.include?(Mongoid::Likeable)
    end

    def liker?
      self.class.included_modules.include?(Mongoid::Liker)
    end
  end
end