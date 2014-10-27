module Mongoid
  module Socialization
    module NotificationModel
      extend ActiveSupport::Concern

      included do
        include ::Mongoid::Timestamps

        # Indexes
        index({ notifier_id: 1, notifier_id: 1 },       { background: true })
        index({ recipient_id: 1, recipient_id: 1 },     { background: true })
        index({ notifiable_id: 1, notifiable_type: 1 }, { background: true })
        index({ target_id: 1, target_id: 1 },           { background: true })

        # Fields
        field       :action,      type: String      # the action that is performing
        field       :parameters,  type: Hash
        field       :is_seen,     type: Boolean,    default: false
        field       :seen_at,     type: Time

        # Relations
        # the actor or performer
        belongs_to  :notifier,    polymorphic: true, inverse_of: :sent_notifications

        # the object that receives this notification
        belongs_to  :recipient,   polymorphic: true, inverse_of: :received_notifications

        # the object that a notifier is being notified about
        belongs_to  :notifiable,  polymorphic: true

        # the object that the action is enacted on
        belongs_to  :target,      polymorphic: true

        # Example:
        # John(notifier) shared a video(notifiable)
        # Geraldine(notifier) posted a photo(notifiable) to her album(target)
        # Veyly(notifier) replied a message(notifiable) on your item(target)

        # Scopes
        scope       :notified_by,  ->(notifier) {
          where(notifier_id: notifier.class.name, notifier_id: notifier.id)
        }

        scope       :notifying,    ->(notifiable) {
          where(notifiable_type: notifiable.class.name, notifiable_id: notifiable.id)
        }
        scope       :unseens,      -> { where(is_seen: false) }
        scope       :seens,        -> { where(is_seen: true) }
        default_scope              -> { order_by(created_at: :desc) }

        # Validations
        validates   :notifier, :action, :recipient,
                    presence: true

        def i18n_key
          "mongoid.#{self.class.name.underscore}"
        end

        def seen!
          update_attributes!(is_seen: true, seen_at: Time.now)
        end

        def unseen!
          update_attributes!(is_seen: false, seen_at: nil)
        end
      end

      module ClassMethods
        def create_notification!(params={})

          create!(params)
          true
        end
      end
    end
  end
end