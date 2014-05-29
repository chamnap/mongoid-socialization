module Mongoid
  module Socialization
    module MessageModel
      extend ActiveSupport::Concern

      included do

        # Fields
        field       :is_seen,         type: Mongoid::Socialization.boolean_klass, default: false
        field       :seen_at,         type: Time
        field       :text,            type: String

        # Relations
        embedded_in :conversation,    class_name: Mongoid::Socialization.conversation_klass.to_s
        belongs_to  :sender,          class_name: Mongoid::Socialization.conversationer_klass.to_s

        validates   :text, :sender,
                    presence: true

        #:nodoc
        def self.remove_validation!(attribute, validator_class)
          _validate_callbacks.reject! do |callback|
            callback.raw_filter.kind_of?(validator_class) &&
              callback.raw_filter.attributes.include?(attribute)
          end
        end

        def seen!
          update_attributes!(is_seen: true, seen_at: Time.now)
        end

        def unseen!
          update_attributes!(is_seen: false, seen_at: Time.now)
        end
      end
    end
  end
end