module Mongoid
  module Socialization
    class Message
      include Mongoid::Document
      include Mongoid::Timestamps
      include MessageModel

      store_in    collection: "mongoid_socialization_messages"
    end
  end
end