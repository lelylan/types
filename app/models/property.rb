class Property
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :default, default: ''
  field :values, type: Array, default: []

  has_and_belongs_to_many :typees

  attr_accessible :name, :default, :values

  validates :name, presence: true
  validates :created_from, presence: true, url: true
end
