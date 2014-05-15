module Mongoid
  module Socialization
    class Follow
      include FollowModel

      store_in    collection: "mongoid_socialization_follows"
    end
  end
end