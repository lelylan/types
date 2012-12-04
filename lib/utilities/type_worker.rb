class TypeWorker

  # Add the new type properties to all devices having the specific type
  def self.add(type_id, property_ids)
    Device.where(type_id: type_id).push_all(:properties,
      TypeWorker.properties_to_add(property_ids)
    )
  end

  # Remove the old type properties to all devices having the specific type
  def self.remove(type_id, property_ids)
    Device.where(type_id: type_id).each { |device|
      TypeWorker.properties_to_remove(device, property_ids)
    }
  end

  private

  def self.properties_to_add(property_ids)
    Property.in(id: property_ids).map do |property|
      { id: property.id, property_id: property.id, value: property.default }
    end
  end

  def self.properties_to_remove(device, property_ids)
    Property.in(id: property_ids).each do |property|
      device.properties.find(property.id).delete
    end
  end
end
