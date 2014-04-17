module Mongoid
  module Likeable
    extend ActiveSupport::Concern

    included do
      field :likes_count, type: Integer,  default: 0
      field :liker_ids,   type: Array,    default: []
    end

    def like!(liker)
      return false if liked_by?(liker)

      push              liker_ids: liker.id
      update_attribute  :likes_count, liker_ids.size
      true
    end

    def unlike!(liker)
      return false unless liked_by?(liker)

      pull              liker_ids: liker.id
      update_attribute  :likes_count, liker_ids.size
      true
    end

    def liked_by?(liker)
      raise Socialization::ArgumentError, "#{liker} is not liker!"  unless liker.respond_to?(:liker?) && liker.liker?

      liker_ids.include?(liker.id)
    end
  end
end