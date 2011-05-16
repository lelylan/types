module View4xxMethods
  # Resource not found
  def should_have_a_not_found_resource(uri)
    page.status_code.should == 404
    page.should have_content "404"
    page.should have_content uri
    page.should have_content "notifications.document.not_found"
    page.should have_content "not found"
    page.should_not have_content 'translation missing'
  end

  # Connection not found
  def should_have_a_not_found_connection(uri)
    page.status_code.should == 404
    page.should have_content "404"
    page.should have_content uri
    page.should have_content "notifications.connection.not_found"
    page.should have_content " not found"
    page.should_not have_content 'translation missing'
  end

  # Resource not valid
  def should_have_a_not_valid_resource
    page.status_code.should == 422
  end
end

RSpec.configuration.include View4xxMethods, :type => :acceptance
