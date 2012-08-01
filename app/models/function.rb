class Function
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :name
  field :resource_owner_id

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :resource_owner_id, presence: true, url: true

  embeds_many :properties, class_name: 'FunctionProperty', cascade_callbacks: true
end
