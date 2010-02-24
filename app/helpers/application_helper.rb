# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    if @notifications
      h truncate("[#{@project.name}] #{@notifications.first.identifier}", 80)
    else
      "Exceptions Begone"
    end
  end
end
