class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :resource_owner_id
  field :default
  field :values, type: Array

  index({ resource_owner_id: 1 }, { background: true })

  attr_protected :resource_owner_id

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  before_save :parse_values
  before_save :touch_types

  before_update :update_devices

  def active_model_serializer; PropertySerializer; end

  private

  def parse_values
    values.map!(&:to_s) if values
  end

  def touch_types
    Type.in(property_ids: id).update_all(updated_at: Time.now)
  end

  def update_devices
    UpdatePropertyWorker.perform_async(id, default: default) if default_changed?
  end
end
