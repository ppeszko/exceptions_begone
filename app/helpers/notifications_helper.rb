module NotificationsHelper
  def sorted_output(enum)
    return [] unless enum
    array = enum.inject([]) do |memo, (key, value)| 
      memo << [key, value]
    end
    array.sort {|a,b| a.first <=> b.first }
  end
end
