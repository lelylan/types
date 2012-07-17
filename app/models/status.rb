class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :name
  field :pending, type: Boolean
  field :created_from

  attr_accessor :properties
  attr_accessible :pending, :name, :properties

  validates :name, presence: true
  validates :pending, inclusion: { in: [true, false], allow_nil: true }

  validates :created_from, presence: true, url: true

  embeds_many :properties, class_name: 'StatusProperty', cascade_callbacks: true
end
