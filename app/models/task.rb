class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :status, type: String
  has_and_belongs_to_many :tags
end
