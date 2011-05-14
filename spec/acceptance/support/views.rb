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

  # Function property non detailed representation
  def should_have_function_property(function_property)
    page.should have_content function_property.uri
    page.should have_content function_property.value
    page.should have_content function_property.secret
    page.should have_content function_property.before
  end

  # Function property detailed representation
  def should_have_function_property_detailed(function_property, property)
    should_have_function_property(function_property)
    should_have_property(property)
  end

  # Property resource representation
  def should_have_property(property)
    page.should have_content property.id.as_json
    page.should have_content property.uri
    page.should have_content property.created_from
    page.should have_content property.name
    page.should have_content property.values.to_json
  end
end

RSpec.configuration.include ViewMethods, :type => :acceptance

