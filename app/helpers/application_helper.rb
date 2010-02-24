# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    if @notifications
      truncate("[#{@project.name}] #{@notifications.first.identifier}", :length => 80)
    else
      "Exceptions Begone"
    end
  end
end
