class Notification < ActiveRecord::Base
  
  belongs_to :stack, :counter_cache => true, :touch => :last_occured_at

  def self.build(project, parameters)
    parameters.symbolize_keys!
    identifier, payload = parameters[:identifier], parameters[:payload].to_json
    notification = self.new(:payload => payload)
    
    notification.stack = Stack.find_or_create(project, parameters[:category], identifier)
            
    if notification.stack.status == "done"
      notification.stack.reset_status!
    end
    
    notification
  end
end
