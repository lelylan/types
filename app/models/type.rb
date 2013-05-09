class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  # TODO Move to Settings
  CATEGORIES = [{ name: 'lights' }, { name: 'locks' }, { name: 'thermostats' }, { name: 'alarms' }, { name: 'meters' }, { name: 'cameras' }, { name: 'windows' }, { name: 'appliances' }, { name: 'garddenings' }, { name: 'sensors' }, { name: 'others' }]

  field :name
  field :description, default: ''
  field :categories, type: Array, default: []
  field :resource_owner_id, type: Moped::BSON::ObjectId

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []
  field :status_ids,   type: Array, default: []

  index({ resource_owner_id: 1 }, { background: true })
  index({ name: 1 }, { background: true })

  attr_accessor :properties, :functions, :statuses
  attr_accessible :name, :description, :categories, :properties, :functions, :statuses, :property_ids, :function_ids, :status_ids

  validates :resource_owner_id, presence: true
  validates :name, presence: true
  validate  :validate_categories

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
    UpdateCategoriesWorker.perform_async(id, categories)    if categories_changed?
  end

  private

  def ids_to_add
    property_ids - property_ids_was
  end

  def ids_to_remove
    property_ids_was - property_ids
  end

  # TODO create proper validator
  def validate_categories
    if (invalid_categories = (categories - CATEGORIES.map{ |category| category[:name]}))
      invalid_categories.each do |category|
        errors.add(:category, category + ' is not valid')
      end
    end
  end
end

