class Project
  include MongoMapper::Document

  key :name
  key :description
  key :warning_threshold
  timestamps!

  has_many :stacks
  has_many :exclusions

  def all_stacks(matching_mode, search_query)
    exclusions_patterns = exclusions.active.map(&:pattern)
    regex_command = matching_mode == :exclude ? "NOT REGEXP" : "REGEXP"

    if search_query
      # search and exclude
    else 
      # exclude
      find("'identifier' : ''")
    end
  end
  

      # if exclusions_patterns.present?
        # sql_pattern = "(#{exclusions_patterns.join('|')})"
        # { :conditions => "identifier #{regex_command} '#{sql_pattern}'" }
      # else
        # {}
      # end


end
