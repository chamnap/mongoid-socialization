module Mongoid
  module Socialization
    class MessageModel
      include Mongoid::Document
      include Mongoid::Timestamps

      # Fields
      field       :is_seen,         type: Mongoid::Socialization.boolean_klass, default: false
      field       :seen_at,         type: Time
      field       :text,            type: String

      # Relations
      embedded_in :conversation,    class_name: Mongoid::Socialization.conversation_model.to_s
      belongs_to  :sender,          class_name: Mongoid::Socialization.conversationer_model.to_s

      validates   :text, :sender,
                  presence: true

      def seen!
        update_attributes!(is_seen: true, seen_at: Time.now)
      end

      def unseen!
        update_attributes!(is_seen: false, seen_at: Time.now)
      end
    end
  end
end