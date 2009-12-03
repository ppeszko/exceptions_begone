require 'test_helper'

class StackTest < ActiveSupport::TestCase

  test "should be possible to set last_occurred_at date on creation" do
    expected_stack = Factory(:stack, :last_occurred_at => (Time.now - 10.days))
    assert expected_stack.last_occurred_at - (Time.now - 10.days) < 10.seconds
  end

  test "find_or_create should create a new object if such " do
    Stack.delete_all
    project = Factory(:project)
    category = "notification"
    identifier = "Nagios what to tell you something"
    
    stack = Stack.find_or_create(project, category, identifier)
    
    assert_not_nil stack
    assert stack.valid?
  end
  
  test "find_or_create should return an existing stack if possible" do
    expected_stack = Factory(:stack)

    stack = Stack.find_or_create(expected_stack.project, expected_stack.category, expected_stack.identifier)
    
    assert stack.valid?
    assert_equal expected_stack, stack
  end
  
  test "find_or_create should not update last_occurred_at" do
    expected_stack = Factory(:stack, :last_occurred_at => (Time.now - 10.days))
    stack = Stack.find_or_create(expected_stack.project, expected_stack.category, expected_stack.identifier)
        
    assert stack.valid?
    assert_equal expected_stack, stack
    assert stack.last_occurred_at - (Time.now - 10.days) < 10.seconds
  end
  
  test "stacks_awaiting_sending should return new stacks and stacks with warnings" do
    new_stack = Factory(:stack)
    already_sent_stack = Factory(:stack, :identifier => "old notification", :email_sent => true)
    
    assert_equal [new_stack], Stack.stacks_awaiting_sending
  end
  
  test "stacks_awaiting_sending should include stacks which exceeded warning threshold" do
    project = Factory(:project, :warning_threshold => 1)
    
    new_stack = Factory(:stack)
    stack_exceeding_threshold = Factory(:stack, :project => project, :identifier => "too many of us", :email_sent => true)
    2.times do 
      Factory(:notification, :stack => stack_exceeding_threshold)
    end

    result = Stack.stacks_awaiting_sending
    assert_equal 2, result.size
    assert result.include?(new_stack)
    assert result.include?(stack_exceeding_threshold)
  end
  
  test "send_notifications_to_users should not set threshold_warning_sent to true on new stacks" do
    project = Factory(:project, :warning_threshold => 1)
    new_stack = Factory(:stack)
    Factory(:notification, :stack => new_stack)
    
    Stack.send_notifications_to_users
    new_stack.reload

    assert_equal false, new_stack.threshold_warning_sent
  end
  
  test "send_notifications_to_users should set threshold_warning_sent to true on thresholded stacks" do
     project = Factory(:project, :warning_threshold => 1)

     stack_exceeding_threshold = Factory(:stack, :project => project, :identifier => "too many of us", :email_sent => true)
     2.times do 
       Factory(:notification, :stack => stack_exceeding_threshold)
     end

     NotificationsMailer.expects(:deliver_notification)
     Stack.send_notifications_to_users

     stack_exceeding_threshold.reload
     assert stack_exceeding_threshold.threshold_warning_sent
   end
  
  test "send_notifications_to_users should send mails when thresholds are reached" do
    project = Factory(:project, :warning_threshold => 1)
    
    stack_exceeding_threshold = Factory(:stack, :project => project, :identifier => "too many of us", :email_sent => true)
    2.times do 
      Factory(:notification, :stack => stack_exceeding_threshold)
    end
    
    NotificationsMailer.expects(:deliver_notification).with() do |stack|
      stack_exceeding_threshold.id == stack.id
    end
    Stack.send_notifications_to_users
  end
  
  test "stacks_awaiting_sending should not return stack for which the warning has been already sent" do
    project = Factory(:project, :warning_threshold => 1)
    
    stack_exceeding_threshold = Factory(:stack, :project => project, :identifier => "too many of us", :email_sent => true, :threshold_warning_sent => true)
    2.times do 
      Factory(:notification, :stack => stack_exceeding_threshold)
    end
        
    assert_equal [], Stack.stacks_awaiting_sending    
  end
  
  test "stacks_awaiting_sending should return stacks which are not excluded" do
    project = Factory(:project, :warning_threshold => 1)
    
    stack = Factory(:stack, :project => project, :identifier => "should be not sent", :email_sent => false, :threshold_warning_sent => false)
    Factory(:notification, :stack => stack)
    
    Factory(:exclusion, :project => project, :pattern => stack.identifier)
      
    assert_equal [], Stack.stacks_awaiting_sending        
  end
end
