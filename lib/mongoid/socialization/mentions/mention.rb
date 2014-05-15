module Mongoid
  module Socialization
    class Mention
      include MentionModel

      store_in    collection: "mongoid_socialization_mentions"
    end
  end
end