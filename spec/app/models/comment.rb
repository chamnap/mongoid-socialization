class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Mentioner

  field         :text,            type: String

  belongs_to    :product,         polymorphic: true
  belongs_to    :page,            polymorphic: true
  belongs_to    :commenter,       class_name: "User"
end