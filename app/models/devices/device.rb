class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  store_in session: 'devices'

  field :resource_owner_id, type: Moped::BSON::ObjectId
  field :creator_id, type: Moped::BSON::ObjectId
  field :name
  field :secret
  field :type_id, type: Moped::BSON::ObjectId
  field :physical
  field :activated_at, type: DateTime, default: ->{ Time.now }
  field :activation_code

  embeds_many :properties, class_name: 'DeviceProperty', cascade_callbacks: true
end
