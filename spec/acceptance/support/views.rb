module ViewMethods
  # Function resource representation
  def should_have_function(function)
    page.should have_content function.name
    page.should have_content function.uri
    page.should have_content function.created_from
  end

  # Function resource not represented
  def should_not_have_function(function)
    page.should_not have_content function.created_from
  end

  # Function property not detailed representation
  def should_have_function_property(function_property)
    page.should have_content function_property.uri
    page.should have_content function_property.value
    page.should have_content function_property.secret.to_s
    page.should have_content function_property.before.to_s
  end

  # Function property detailed representation
  def should_have_function_property_detailed(function_property, function, property)
    should_have_function_property(function_property)
    page.should have_content function.name
    page.should have_content function.uri
    page.should have_content property.name
    page.should have_content property.uri
  end

  # Property resource representation
  def should_have_property(property)
    page.should have_content property.id.as_json
    page.should have_content property.uri
    page.should have_content property.created_from
    page.should have_content property.name
    page.should have_content property.values.to_json
    page.should have_content property.default
  end

  # Property resource not represented
  def should_not_have_property(property)
    page.should_not have_content property.uri
  end

  # Type resource representation
  def should_have_type(type)
    page.should have_content type.id.as_json
    page.should have_content type.uri
    page.should have_content type.created_from
    page.should have_content type.name
    page.should have_content type.public.to_s
  end

  # Type resource not represented
  def should_not_have_type(property)
    page.should_not have_content property.uri
  end

  # Status resource representation
  def should_have_status(status)
    page.should have_content status.id.as_json
    page.should have_content status.uri
    page.should have_content status.created_from
    page.should have_content status.name
  end

  # Status resource not represented
  def should_not_have_status(status)
    page.should_not have_content status.uri
  end

  # Status property resource representation
  def should_have_status_property(status_property)
    page.should have_content status_property.uri
    page.should have_content status_property.pending.to_s
    page.should have_content status_property.values.to_json
  end

  # Status property detailed resource representation
  def should_have_status_property_detailed(function_property, status, property)
    should_have_status_property(function_property)
    page.should have_content status.name
    page.should have_content status.uri
    page.should have_content property.name
    page.should have_content property.uri
  end

  # Status property connections
  def should_have_status_connections
    # categories 
    should_have_category(@category)
    # properties
    should_have_property(@status)
    should_have_property(@intensity)
    # functions
    should_have_function(@set_intensity)
    should_have_function(@turn_off)
    should_have_function(@turn_on)
    # statuses
    should_have_status(@is_setting_intensity)
    should_have_status(@is_setting_max)
    should_have_status(@has_set_intensity)
    should_have_status(@has_set_max)
  end

  # Category resource representation 
  def should_have_category(category)
    page.should have_content category.name
    page.should have_content category.uri
    page.should have_content category.id.as_json
    page.should have_content category.created_from
  end

  # Category resource not represented
  def should_not_have_category(category)
    page.should_not have_content "\"#{category.uri}\""
  end
end

RSpec.configuration.include ViewMethods, :type => :acceptance

