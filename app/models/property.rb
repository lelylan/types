class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :resource_owner_id
  field :default, default: ''
  field :suggested, type: Hash, default: {}

  index({ resource_owner_id: 1 }, { background: true })

  attr_accessible :name, :default, :suggested

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  before_save :touch_types
  before_update :update_devices
  before_destroy :destroy_dependant

  def active_model_serializer
    PropertySerializer
  end

  private

  def touch_types
    Type.in(property_ids: id).update_all(updated_at: Time.now)
  end

  def update_devices(attributes = {})
    attributes['default']   = default   if default_changed?
    attributes['suggested'] = suggested if suggested_changed?

    UpdatePropertyWorker.perform_async(id, attributes)
  end

  def destroy_dependant
    Function.where('properties.property_id' => id).each { |f| f.properties.where(property_id: id).delete_all }
    Status.where('properties.property_id' => id).each { |s| s.properties.where(property_id: id).delete_all }
    Type.in(property_ids: id).each { |t| t.update_attributes(property_ids: t.property_ids - [id] ) }
  end
end
