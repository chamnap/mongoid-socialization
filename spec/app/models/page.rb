class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Likeable
  include Mongoid::Followable

  field   :name, type: String
end