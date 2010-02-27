# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def submit_button(name)
    haml_tag :button, :type => "submit" do
      haml_tag :span, :class => "button" do
        haml_concat name
      end
    end
  end

  def title(link = false)
    if @notifications
      if link
        haml_tag :a, :href => project_stacks_path(@project), :title => "[#{@project.name}] #{@notifications.first.stack.identifier}" do
          haml_concat truncate("[#{@project.name}] #{@notifications.first.stack.identifier}", :length => 70)
        end
        # haml_tag :a, :href => project_stacks_path(@project, :atom), :title => "Atom feed", :class => "atom-feed" do
        #   haml_concat "Atom feed"
        # end
      else
        truncate("[#{@project.name}] #{@notifications.first.stack.identifier}", :length => 80)
      end
    else
      "Exceptions Begone"
    end
  end

end
