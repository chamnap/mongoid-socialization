class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Likeable

  field   :name, type: String
end