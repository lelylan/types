class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :function_id, type: Moped::BSON::ObjectId
  field :name

  index({ resource_owner_id: 1 }, { background: true })

  attr_accessor :properties, :function
  attr_accessible :name, :properties, :function

  validates :name,              presence: true
  validates :resource_owner_id, presence: true

  embeds_many :properties, class_name: 'StatusProperty', cascade_callbacks: true

  before_save :set_function
  before_save :touch_types
  before_destroy :destroy_dependant

  def active_model_serializer
    StatusSerializer
  end

  private

  def touch_types
    Type.in(status_ids: id).update_all(updated_at: Time.now)
  end

  def destroy_dependant
    Type.in(status_ids: id).each { |t| t.update_attributes(status_ids: t.status_ids - [id] ) }
  end

  def set_function
    self.function_id = function[:id] if (function and function[:id])
  end
end
