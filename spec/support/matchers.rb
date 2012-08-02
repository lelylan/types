RSpec::Matchers.define :authorize do |expected|
  match do |actual|
    method, uri = expected.squish.split ' '
    page.driver.send method, uri
    page.status_code != 401
  end
end

