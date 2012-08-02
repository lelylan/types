class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :resource_owner_id
  field :default, default: ''
  field :values, type: Array, default: []

  attr_protected :resource_owner_id

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  before_save :parse_values

  private 

  def parse_values
    values.map!(&:to_s)
  end
end
