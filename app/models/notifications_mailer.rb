class NotificationsMailer < ActionMailer::Base
  
  helper :notifications
  
  def notification(stack, sent_at = Time.now)
    subject     "[#{stack.project.name}] [#{stack.category}] [count:#{stack.notifications_count}] #{stack.identifier}"
    recipients  stack.project.name == "production" ? "rails-production-exceptions@lists.xing.com" : SimpleConfig.for(:application).notification_email
    from        'rails-developers@lists.xing.com'
    sent_on     sent_at
    headers     "importance" => "high", "x-priority" => 1 if stack.warning_threshold_exceeded?
    
    body        :stack => stack, :payload => ActiveSupport::JSON.decode(stack.notifications.last.payload)
  end

end
