class TypeWorker

  # Add the new type properties to all devices having the specific type
  def self.add(type_id, property_ids)
    pp ':::: Adding properties', property_ids, 'to devices having type', type_id if ENV['DEBUG']

    TypeWorker.touch_devices(type_id)
    Device.where(type_id: type_id).push_all(:properties,
      TypeWorker.properties_to_add(type_id, property_ids)
    )
  end

  # Remove the old type properties to all devices having the specific type
  def self.remove(type_id, property_ids)
    pp ':::: Removing properties', property_ids, 'to devices having type', type_id if ENV['DEBUG']

    TypeWorker.touch_devices(type_id)
    Device.where(type_id: type_id).each do |device|
      TypeWorker.properties_to_remove(device, property_ids)
    end
  end

  def self.updates(property_id, options)
    pp ':::: Updating all devices with property', property_id if ENV['DEBUG']

    attributes  = TypeWorker.attributes_updated(options)
    property_id = Moped::BSON::ObjectId(property_id)
    TypeWorker.inactive_devices(property_id).update_all(updated_at: Time.now)
    TypeWorker.inactive_devices(property_id).each do |device|
      device.properties.find(property_id).update_attributes(attributes)
    end
  end

  def self.categories(type_id, categories)
    pp ':::: Upadating categories', categories, 'to devices having type', type_id if ENV['DEBUG']

    TypeWorker.touch_devices(type_id)
    Device.where(type_id: type_id).update_all(categories: categories)
  end

  private

  def self.properties_to_add(type_id, property_ids)
    Property.in(id: property_ids).map do |property|
      { _id: property.id, property_id: property.id, value: property.default }
    end
  end

  def self.properties_to_remove(device, property_ids)
    device.properties.in(_id: property_ids).delete_all
  end

  def self.inactive_devices(property_id)
    Device.where('properties._id' => property_id, activated_at: nil)
  end

  def self.touch_devices(type_id)
    Device.where(type_id: type_id).update_all(updated_at: Time.now)
  end

  def self.attributes_updated(options, result = {})
    result['value'] = options['default'] if options['default']
    return result
  end
end
