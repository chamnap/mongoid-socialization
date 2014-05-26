module Mongoid::Socialization
  class Error < StandardError
    attr_reader :object

    def initialize(object, message)
      @object    = object
      @message  = message
    end
  end
end