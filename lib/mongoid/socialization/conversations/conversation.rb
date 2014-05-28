module Mongoid
  module Socialization
    class Conversation
      include ConversationModel

      store_in    collection: "mongoid_socialization_conversations"
    end
  end
end