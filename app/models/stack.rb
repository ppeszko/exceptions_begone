class Stack 
  include MongoMapper::Document

  key :identifier, String
  key :status, Integer
  key :notifications_count
  key :category
  key :email_sent, Integer, :default => 0
  key :threshold_warning_sent, Integer, :default => 0
  key :last_occurred_at
  key :username, String
  
  timestamps!

  belongs_to :project
  many :notifications, :dependent => :destroy
    
  # named_scope :for_email_notifications, :conditions => {:email_sent => false}
  # named_scope :exceeding_warning_threshold, lambda { |threshold| {:conditions => ["notifications_count > ?", threshold]} }
  # named_scope :warning_not_sent, :conditions => ["threshold_warning_sent != ?", true]

  @@status_to_integer = {"incoming" => 0, "processing" => 1, "done" => 2}
  @@integer_to_status = @@status_to_integer.invert
   
  before_create do |record|
    record.status = @@integer_to_status[0]
    record.last_occurred_at = Time.now unless record.last_occurred_at
  end

  before_update do |record|
    record.last_occurred_at = Time.now
  end
    
  class << self
    def conditions_for_exclusions(exclusions, matching_mode)
      exclusions_patterns = exclusions.active.map(&:pattern)
      
      regex_command = matching_mode == :exclude ? "NOT REGEXP" : "REGEXP"
      
      if exclusions_patterns.present?
        sql_pattern = "(#{exclusions_patterns.join('|')})"
        { :conditions => "identifier #{regex_command} '#{sql_pattern}'" }
      else
        {}
      end
    end
  
    def condition_for_filter(filter)
      case filter
      when "all"
        {}
      when "done"
        {:status => 2}
      when "incoming"
        {:status => 0}
      when "in_progress"
        {:status => 1}
      else
        {:status => {:$not => {:$in => [2]}}}
      end
    end
    
    def send_notifications_to_users
      stacks = stacks_awaiting_sending
      logger.info("[EMAIL] sending notification about following stacks: #{stacks.map(&:id)}")
      stacks.each do |stack|
        NotificationsMailer.deliver_notification(stack)
        stack.email_sent = 1
        stack.threshold_warning_sent = 1 if stack.warning_threshold_exceeded?
        stack.save!
      end
    end

    def stacks_awaiting_sending
      awaiting_stacks = []
      Project.all.each do |project|
        exclusion_patterns = project.exclusions.all(:enabled => true).map(&:pattern)
        if exclusion_patterns.present?
          awaiting_stacks += project.stacks.all({:email_sent => 0, :identifier => {:$not => /#{exclusion_patterns.join('|')}/}})
          awaiting_stacks += project.stacks.all(:identifier => {:$not => /#{exclusion_patterns.join('|')}/}, :threshold_warning_sent => 0, :notifications_count => {:$gt => project.warning_threshold})
        else
          awaiting_stacks += project.stacks.all(:email_sent => 0)
          awaiting_stacks += project.stacks.all(:threshold_warning_sent => 0, :notifications_count => {:$gt => project.warning_threshold})
        end
      end
      awaiting_stacks
    end
    
    def find_or_create(project, category, identifier)
      find_or_create_by_project_id_and_category_and_identifier(project.id, category, identifier)
    end

    def logger
      @@logger ||= RAILS_DEFAULT_LOGGER
    end
  end
  
  def reset_status!
    self.status = @@integer_to_status[0]
    self.email_sent = 0
    self.threshold_warning_sent = 0
    self.save!
  end

  def status
    @@integer_to_status.fetch(self[:status], @@integer_to_status[0])
  end
  
  def status=(s)
    self[:status] = s.is_a?(Integer) ? s : @@status_to_integer[s]
  end
  
  def cycle_status
    actual_integer_status = @@status_to_integer[status]
    @@integer_to_status.fetch(actual_integer_status + 1, @@integer_to_status[0])
  end
  
  def can_change_status?(username)
    if status == @@integer_to_status[0]
      true
    else
      self.username == username
    end
  end
  
  def warning_threshold_exceeded?
    notifications_count > project.warning_threshold
  end
end
