require 'test_helper'

class NotificationsMailerTest < ActionMailer::TestCase
  
  test "sending notification via email" do
    payload = {
      "session" => "", 
      "request_environment" => {"HTTP_HOST" => "www.xing.com", "SERVER_NAME" => "www.xing.com"},
      "parameters" => {},
      "backtrace" => ["line1", "line2"]
    }
    notification = Factory.create(:notification, :payload => ActiveSupport::JSON.encode(payload))
    stack = notification.stack
    subject = "[#{stack.project.name}] [#{stack.category}] [count:#{stack.notifications_count}] #{stack.identifier}"
    
    email = NotificationsMailer.deliver_notification(stack) 

    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['your_email_address@example.com'], email.to
    assert_equal subject, email.subject
    assert_match /#{stack.identifier}/, email.body
    
    payload.each do |key, value|
      assert_match /#{key}/, email.body, "body does not contain #{key}"
      value.each do |a,b|
        if b
          assert_match /#{a}.+#{b}/, email.body, "body does not contain #{a}: #{b}"
        else
          assert_match /#{a}/, email.body, "body does not contain #{a}"
        end
      end
    end
  end
  
  test "should not rise exceptions on nested hashes" do
    payload = { "hash_in_hash" => {"hash1" => {"hash2" => "value"}} }
    notification = Factory.create(:notification, :payload => ActiveSupport::JSON.encode(payload))
    
    assert_nothing_raised do
      NotificationsMailer.deliver_notification(notification.stack)
    end
  end
  
  test "notfication emails from production should be sent to production exceptions list" do
    notification = Factory.create(:notification, :payload => ActiveSupport::JSON.encode({}))
    notification.stack.project.name = "production"
    
    email = NotificationsMailer.deliver_notification(notification.stack)
    assert_equal ["rails-production-exceptions@lists.xing.com"], email.to
  end
  
  test "notification emails should be send with normal priority" do
    notification = Factory.create(:notification, :payload => ActiveSupport::JSON.encode({}))
    
    email = NotificationsMailer.deliver_notification(notification.stack)
    assert_nil email.header["importance"]
    assert_nil email.header["x-priority"]
  end
  
  test "notification emails should be send with high priority if the threshold was reached" do
    stack = Factory(:stack, :identifier => "warning_threshold set to 2", :notifications_count => 3)
    notification = Factory(:notification, :stack => stack)
    
    email = NotificationsMailer.deliver_notification(notification.stack)
    assert_not_nil email.header["importance"]
    assert_not_nil email.header["x-priority"]
  end
  
  test "notification email should contain link back to exceptions_begone server" do
    stack = Factory(:stack, :identifier => "warning_threshold set to 2")
    notification = Factory(:notification, :stack => stack)
    
    email = NotificationsMailer.deliver_notification(notification.stack)
    assert_match /http:\/\/example.com\/projects\/#{stack.project.id}\/stacks\/#{stack.id}/, email.body
  end
  
  test "backtrace should not be sorted" do
    payload = { "backtrace" => ["b_line", "a_line"] }
    notification = Factory.create(:notification, :payload => ActiveSupport::JSON.encode(payload))
    
    email = NotificationsMailer.deliver_notification(notification.stack)
    assert_match /b_line\n.*a_line/, email.body
  end
  
end
