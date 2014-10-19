module Mongoid
  module Socialization
    module Notifiable
      extend ActiveSupport::Concern

      included do
        has_many :notifications,  class_name: Mongoid::Socialization.notification_klass_name, :as => :notifiable
      end
    end
  end
end