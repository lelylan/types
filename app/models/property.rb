class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :resource_owner_id
  field :default
  field :values, type: Array

  attr_protected :resource_owner_id

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  before_save :parse_values

  private 

  def parse_values
    values.map!(&:to_s) if values
  end
end
