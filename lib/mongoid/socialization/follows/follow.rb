module Mongoid
  module Socialization
    class Follow
      include Mongoid::Document
      include Mongoid::Timestamps
      include FollowModel

      store_in    collection: "mongoid_socialization_follows"
    end
  end
end