module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /projects page/
      projects_path
    when /projects create page/
      new_project_path
    when /the login page/
      'login'
    when /the home\s?page/
      '/'
    when /projects\/(.+)\/exclusions/
      project = Project.find_by_name($1)
      project_exclusions_path(project)
    when /projects\/(.+)\/stacks/
      project = Project.find_by_name($1)
      project_stacks_path(project)
    when /"projects\/(.+)"$/
      project = Project.find_by_name($1)
      project_path(project)
        
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
