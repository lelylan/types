class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :name

  index({ resource_owner_id: 1 }, { background: true })

  attr_accessor  :properties
  attr_protected :resource_owner_id

  validates :name,              presence: true
  validates :resource_owner_id, presence: true

  embeds_many :properties, class_name: 'StatusProperty', cascade_callbacks: true

  before_save :touch_types

  def active_model_serializer; StatusSerializer; end

  private

  def touch_types
    Type.in(status_ids: id).update_all(updated_at: Time.now)
  end
end
