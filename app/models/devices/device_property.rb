class DeviceProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  store_in session: 'devices'

  field :_id, default: ->{ property_id }, type: Moped::BSON::ObjectId
  field :property_id, type: Moped::BSON::ObjectId
  field :value
  field :expected
  field :pending
  field :accepted, type: Array
  embedded_in :device
end
