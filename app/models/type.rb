class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :name
  field :resource_owner_id, type: Moped::BSON::ObjectId

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []
  field :status_ids,   type: Array, default: []
  field :category_ids, type: Array, default: []

  index({ resource_owner_id: 1 })
  index({ name: 1 })

  attr_accessor :properties, :functions, :statuses, :categories
  attr_protected :resource_owner_id

  validates :resource_owner_id, presence: true
  validates :name,              presence: true

  validates :properties, uri: true
  validates :functions,  uri: true
  validates :statuses,   uri: true
  validates :properties, uri: true

  before_save :find_properties, :find_functions, :find_statuses, :find_categories

  def find_properties
    self.property_ids = find_ids(properties) if not properties.nil?
  end

  def find_functions
    self.function_ids = find_ids(functions) if not functions.nil?
  end

  def find_statuses
    self.status_ids = find_ids(statuses) if not statuses.nil?
  end

  def find_categories
    self.category_ids = find_ids(categories) if not categories.nil?
  end
end

