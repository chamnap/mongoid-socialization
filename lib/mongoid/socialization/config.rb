module Mongoid
  module Socialization
    extend self
    attr_accessor :conversationer_klass_name

    MODULES = %w( like follow wish_list mention conversation message )

    MODULES.each do |module_name|
      module_klass_name = "#{module_name}_klass_name"

      # like_klass_name=
      define_method("#{module_klass_name}=") do |klass_name|
        instance_variable_set("@#{module_klass_name}", klass_name)
      end

      # like_klass_name
      define_method("#{module_klass_name}") do
        instance_variable_get("@#{module_klass_name}").presence || "Mongoid::Socialization::#{module_name.camelize}"
      end

      # like_klass
      define_method("#{module_name}_klass") do
        if instance_variable_get("@#{module_name}_klass")
          instance_variable_get("@#{module_name}_klass")
        else
          instance_variable_set("@#{module_name}_klass", send("#{module_klass_name}").constantize)
        end
      end
    end

    def conversationer_klass
      @conversationer_klass ||= @conversationer_klass_name.constantize
    end

    def boolean_klass
      defined?(Mongoid::Boolean) ? Mongoid::Boolean : Boolean
    end
  end
end