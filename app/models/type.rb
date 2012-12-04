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
    AddPropertiesWorker.perform_async(id, ids_to_add)       if ids_to_add    != []
    RemovePropertiesWorker.perform_async(id, ids_to_remove) if ids_to_remove != []
  end

  private

  def ids_to_add; property_ids - property_ids_was; end
  def ids_to_remove; property_ids_was - property_ids; end
end

