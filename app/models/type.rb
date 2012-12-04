class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :name
  field :resource_owner_id, type: Moped::BSON::ObjectId

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []
  field :status_ids,   type: Array, default: []

  index({ resource_owner_id: 1 }, { background: true })
  index({ name: 1 }, { background: true })

  attr_accessor :properties, :functions, :statuses
  attr_protected :resource_owner_id

  validates :resource_owner_id, presence: true
  validates :name,              presence: true

  validates :properties, uri: true
  validates :functions,  uri: true
  validates :statuses,   uri: true
  validates :properties, uri: true

  before_save   :find_properties, :find_functions, :find_statuses
  before_update :update_devices

  def active_model_serializer; TypeSerializer; end

  def find_properties
    self.property_ids = find_ids(properties) if not properties.nil?
  end

  def find_functions
    self.function_ids = find_ids(functions) if not functions.nil?
  end

  def find_statuses
    self.status_ids = find_ids(statuses) if not statuses.nil?
  end

  def update_devices
    add_properties    if properties_id_to_add    != []
    remove_properties if properties_id_to_remove != []
  end

  def add_properties
    Device.where(type_id: id).push_all(:properties, properties_to_add)
  end

  def remove_properties
    Device.where(type_id: id).each do |device|
      Property.in(id: properties_id_to_remove).each do |property|
        device.properties.find(property.id).delete
      end
    end
  end

  private

  def properties_to_add
    Property.in(id: properties_id_to_add).map do |property|
      { id: property.id, property_id: property.id, value: property.default }
    end
  end

  def properties_id_to_add
    property_ids - property_ids_was
  end

  def properties_id_to_remove
    property_ids_was - property_ids
  end
end

