class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :properties, type: Array, default: []
  field :functions, type: Array, default: []

  embeds_many :type_statuses

  attr_accessible :name, :properties, :functions

  validates :name, presence: true
  validates :uri, presence:true, url: true
  validates :created_from, presence: true, url: true
end
