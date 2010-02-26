class Stack < ActiveRecord::Base
  include MongoMapper::Document

  belongs_to :user
  belongs_to :project
  has_many :notifications, :dependent => :destroy
    
  named_scope :with_status, lambda { |filter| condition_for_filter(filter) }
  named_scope :for_email_notifications, :conditions => {:email_sent => false}
  named_scope :not_done, :conditions => ["status != 2"]
  named_scope :with_identifier, lambda { |identifier| {:conditions => ["identifier LIKE ?", "%#{identifier}%"]} } 
  named_scope :exceeding_warning_threshold, lambda { |threshold| {:conditions => ["notifications_count > ?", threshold]} }
  named_scope :warning_not_sent, :conditions => ["threshold_warning_sent != ?", true]
  named_scope :exclusions_matching, lambda { |exclusions, matching_mode| conditions_for_exclusions(exclusions, matching_mode) }

  @@status_to_integer = {"incoming" => 0, "processing" => 1, "done" => 2}
  @@integer_to_status = @@status_to_integer.invert
    
  def before_create
    self.status = @@integer_to_status[0]
    self.last_occurred_at = Time.now unless self.last_occurred_at
  end
  
  def before_update
    self.last_occurred_at = Time.now
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
        {:conditions => ["status = 2"]}
      when "incoming"
        {:conditions => ["status = 0"]}
      when "in_progress"
        {:conditions => ["status = 1"]}
      else
        {:conditions => ["status != 2"]}
      end
    end
    
    def send_notifications_to_users
      stacks = stacks_awaiting_sending
      Rails.logger.info("[EMAIL] sending notification about following stacks: #{stacks.map(&:id)}")
      stacks.each do |stack|
        NotificationsMailer.deliver_notification(stack)
        stack.email_sent = true
        stack.threshold_warning_sent = true if stack.warning_threshold_exceeded?
        stack.save!
      end
    end
    
    def stacks_awaiting_sending
      awaiting_stacks = []
      Project.all.each do |project|
        awaiting_stacks += project.stacks.for_email_notifications.exclusions_matching(project.exclusions, :exclude)
        awaiting_stacks += project.stacks.exceeding_warning_threshold(project.warning_threshold).warning_not_sent.exclusions_matching(project.exclusions, :exclude)
      end
      awaiting_stacks
    end
    
    def find_or_create(project, category, identifier)
      find_or_create_by_project_id_and_category_and_identifier(project.id, category, identifier)
    end
  end
  
  def reset_status!
    self.status = @@integer_to_status[0]
    self.email_sent = false
    self.threshold_warning_sent = false
    self.save!
  end

  def status
    @@integer_to_status.fetch(self[:status], @@integer_to_status[0])
  end
  
  def status=(s)
    self[:status] = @@status_to_integer[s]
  end
  
  def cycle_status
    actual_integer_status = @@status_to_integer[status]
    @@integer_to_status.fetch(actual_integer_status + 1, @@integer_to_status[0])
  end
  
  def can_change_status?(user)
    if status == @@integer_to_status[0]
      true
    else
      self.user == user
    end
  end
  
  def warning_threshold_exceeded?
    notifications_count > project.warning_threshold
  end
end
