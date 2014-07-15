class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  # TODO Move to Settings
  CATEGORIES = [{ tag: 'lights', name: 'Lights' }, { tag: 'locks', name: 'Locks' }, { tag: 'thermostat', name: 'Thermostats' }, { tag: 'alarms', name: 'Alarms' }, { tag: 'meters', name: 'Meters' }, { tag: 'cameras', name: 'IP Cameras' }, { tag: 'windows', name: 'Windows' }, { tag: 'appliances', name: 'Appliances' }, { tag: 'gardenings', name: 'Gardenings' }, { tag: 'sensors', name: 'Sensors' }, { tag: 'others', name: 'Other categories' }]

  field :name
  field :description, default: ''
  field :category
  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :popular, type: Boolean, default: false

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []
  field :status_ids,   type: Array, default: []

  index({ resource_owner_id: 1 }, { background: true })
  index({ name: 1 }, { background: true })

  attr_accessor :properties, :functions, :statuses
  attr_accessible :name, :description, :category, :properties, :functions, :statuses, :property_ids, :function_ids, :status_ids

  validates :resource_owner_id, presence: true
  validates :name, presence: true
  validate  :validate_category

  before_save :find_properties, :find_functions, :find_statuses
  before_update :update_devices

  def active_model_serializer; TypeSerializer; end

  def find_properties
    self.property_ids = properties.map { |p| Moped::BSON::ObjectId(p) } if not properties.nil?
  end

  def find_functions
    self.function_ids = functions.map { |f| Moped::BSON::ObjectId(f) } if not functions.nil?
  end

  def find_statuses
    self.status_ids = statuses.map { |s| Moped::BSON::ObjectId(s) } if not statuses.nil?
  end

  def update_devices
    AddPropertiesWorker.perform_async(id, ids_to_add)       if ids_to_add    != []
    RemovePropertiesWorker.perform_async(id, ids_to_remove) if ids_to_remove != []
    UpdateCategoryWorker.perform_async(id, category)        if category_changed?
  end

  private

  def ids_to_add
    property_ids - property_ids_was
  end

  def ids_to_remove
    property_ids_was - property_ids
  end

  # TODO create proper validator to check if CATEGORIES contains the type category
  def validate_category
    invalid = ([category] - CATEGORIES.map{ |category| category[:tag]})[0]
    errors.add(:category, category + ' is not valid') if (invalid)
  end
end

