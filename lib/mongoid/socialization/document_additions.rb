module Mongoid
  module Socialization
    module DocumentAdditions
      extend ActiveSupport::Concern

      METHODS = %w( likeable? liker? followable? follower? wish_lister? wish_listable? mentioner? mentionable? )

      METHODS.each do |method|
        define_method(method) do
          self.class.send(method)
        end
      end

      module ClassMethods
        METHODS.each do |method|
          define_method(method) do
            module_name = "Mongoid::#{method.gsub(/\?$/, '').camelize}"
            included_modules.include?(module_name.constantize)
          end
        end
      end
    end
  end
end