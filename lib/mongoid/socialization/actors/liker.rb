module Mongoid
  module Liker
    extend ActiveSupport::Concern

    def like!(likeable)
      raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:likeable?) && likeable.likeable?

      likeable.like!(self)
    end

    def unlike!(likeable)
      raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:likeable?) && likeable.likeable?

      likeable.unlike!(self)
    end

    def liked?(likeable)
      raise Socialization::ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:likeable?) && likeable.likeable?

      likeable.liked_by?(self)
    end
  end
end