module Mongoid
  module Socialization
    class Message
      include MessageModel

      store_in    collection: "mongoid_socialization_messages"
    end
  end
end