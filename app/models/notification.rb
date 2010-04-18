class Notification 
  include MongoMapper::Document

  key :identifier
  key :payload
  key :status
  timestamps!

  belongs_to :stack #, :counter_cache => true, :touch => :last_occured_at

  before_create do |record|
    record.stack.notifications_count += 1
  end

  def self.build(project, parameters)
    parameters.symbolize_keys!
    identifier, payload = parameters[:identifier], parameters[:payload].to_json

    notification = self.new(:payload => payload, :identifier => identifier)
    notification.stack = Stack.find_or_create(project, parameters[:category], replace_numbers(identifier))

    if notification.stack.status == "done"
      notification.stack.reset_status!
    end

    notification
  end

  private 

  def self.replace_numbers(identifier)
    identifier.gsub(/(\d)+/, '%s')
  end
end
