module Mongoid
  module Socialization
    class Mention
      include Mongoid::Document
      include Mongoid::Timestamps
      include MentionModel

      store_in    collection: "mongoid_socialization_mentions"
    end
  end
end