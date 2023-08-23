class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Enumerize

  field :title, type: String
  field :description, type: String
  enumerize :status, in: [:not_start, :start, :finish], default: :not_start
  field :tags, type: Array, default: []
  field :deleted_at, type: Time

  validates :title, presence: true

  def soft_delete
    update(deleted_at: Time.now)
  end

  def restore

    update(deleted_at: nil)

  end

end
