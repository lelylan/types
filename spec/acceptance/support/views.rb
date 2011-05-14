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
end

RSpec.configuration.include ViewMethods, :type => :acceptance

