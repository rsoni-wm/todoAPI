class Task
  include Mongoid::Document
include Mongoid::Timestamps
# include Mongoid::Paranoia
  extend Enumerize


  field :title, type: String
  field :description, type: String
  enumerize :status, in: [:not_start, :start, :finish], default: :not_start

  field :deleted_at, type: Time
  field :tags, type: Array, default: []


  validates :title, presence: true
  def soft_delete
    update(deleted_at: Time.now)
  end
  def restore
    update(deleted_at: nil)
  end
end
