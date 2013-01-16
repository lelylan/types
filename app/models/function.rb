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

  before_save :touch_types
  before_destroy :destroy_dependant

  def active_model_serializer; FunctionSerializer; end

  private

  def touch_types
    Type.in(function_ids: id).update_all(updated_at: Time.now)
  end

  def destroy_dependant
    Type.in(function_ids: id).each { |t| t.update_attributes(function_ids: t.function_ids - [id] ) }
  end
end
