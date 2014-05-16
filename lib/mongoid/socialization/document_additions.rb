module Mongoid
  module Socialization
    module DocumentAdditions
      extend ActiveSupport::Concern

      VICTIM_ACTOR_METHODS = %w( likeable? liker? followable? follower? wish_lister? wish_listable? mentioner? mentionable? )
      MODULE_KLASS_METHODS = %w( like_klass follow_klass wish_list_klass mention_klass )

      VICTIM_ACTOR_METHODS.each do |method|
        define_method(method) do
          self.class.send(method)
        end
      end

      MODULE_KLASS_METHODS.each do |method|
        define_method(method) do
          self.class.send(method)
        end
      end

      module ClassMethods
        VICTIM_ACTOR_METHODS.each do |method|
          define_method(method) do
            module_name = "Mongoid::Socialization::#{method.gsub(/\?$/, '').camelize}"
            included_modules.include?(module_name.constantize)
          end
        end

        MODULE_KLASS_METHODS.each do |method|
          define_method(method) do
            Mongoid::Socialization.send(method)
          end
        end
      end
    end
  end
end