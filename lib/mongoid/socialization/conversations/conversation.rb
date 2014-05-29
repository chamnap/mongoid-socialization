module Mongoid
  module Socialization
    class Conversation
      include Mongoid::Document
      include Mongoid::Timestamps
      include ConversationModel

      store_in    collection: "mongoid_socialization_conversations"
    end
  end
end