class Function
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :name

  index({ resource_owner_id: 1 }, { background: true })

  attr_accessible :name, :properties

  validates :name, presence: true
  validates :resource_owner_id, presence: true

  embeds_many :properties, class_name: 'FunctionProperty', cascade_callbacks: true

  def active_model_serializer; FunctionSerializer; end
end
