module Mongoid
  module Socialization
    class Message
      include Mongoid::Document
      include Mongoid::Timestamps
      include MessageModel
    end
  end
end