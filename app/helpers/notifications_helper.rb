module NotificationsHelper
  def sorted_output(enum)
    Rails.logger.error enum.inspect
    return [] unless enum
    array = enum.inject([]) do |memo, (key, value)| 
      memo << [key, value]
    end
    array.sort {|a,b| a.first <=> b.first }
  end
end
