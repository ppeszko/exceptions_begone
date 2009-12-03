require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "build method should serialize payload to json" do
    identifier = "some identifier"
    category = "exception"
    payload = {:environment => "production", :backtrace => "\/asdsd\/ asdfs \n sdfasdf"}
    project = Factory(:project)
    attributes = {:identifier => identifier, :category => category, :payload => payload}
        
    notification = Notification.build(project, attributes)
    assert_not_nil notification.payload
    assert_equal payload.to_json, notification.payload
  end
end