class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :name
  field :created_from

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []
  field :status_ids, type: Array, default: []
  field :category_ids, type: Array, default: []

  attr_accessor :properties, :functions, :statuses, :categories
  attr_accessible :name, :properties, :functions, :statuses, :categories

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  before_save :find_properties, :find_functions, :find_statuses, :find_categories

  def find_properties
    self.property_ids = find_resources(properties) if not properties.nil?
  end

  def find_functions
    self.function_ids = find_resources(functions) if not functions.nil?
  end

  def find_statuses
    self.status_ids = find_resources(statuses) if not statuses.nil?
  end

  def find_categories
    self.category_ids = find_resources(categories) if not categories.nil?
  end
end

