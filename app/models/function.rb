class Function
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :name

  attr_accessible :name, :properties

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  embeds_many :properties, class_name: 'FunctionProperty', cascade_callbacks: true
end
