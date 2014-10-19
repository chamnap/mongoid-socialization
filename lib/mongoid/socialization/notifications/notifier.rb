module Mongoid
  module Socialization
    module Notifier
      extend ActiveSupport::Concern

      included do
        has_many :sent_notifications,     class_name: Mongoid::Socialization.notification_klass_name,
                                          inverse_of: :notifier

        has_many :received_notifications, class_name: Mongoid::Socialization.notification_klass_name,
                                          inverse_of: :recipient
      end

      def send_notification!(options={})
        options = options.reverse_merge(notifier: self)

        Mongoid::Socialization.notification_klass.create_notification!(options)
      end
    end
  end
end