class Typee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :public, default: 'true'

  has_and_belongs_to_many :properties
  has_and_belongs_to_many :functions
  #has_and_belongs_to_many :categories
  #has_and_belongs_to_many :statuses

  attr_accessible :name, :public

  validates :name, presence: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: ['true', 'false'] }
end
