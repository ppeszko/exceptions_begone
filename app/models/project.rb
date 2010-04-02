class Project
  include MongoMapper::Document

  key :name
  key :description
  key :warning_threshold
  timestamps!

  many :stacks
  many :exclusions

  def all_stacks(matching_mode, search_query)
    # exclusions_patterns = exclusions.active.map(&:pattern)
    # regex_command = matching_mode == :exclude ? "NOT REGEXP" : "REGEXP"

    exclusion_patterns = exclusions.all(:enabled => true).map(&:pattern)

    if search_query
      if exclusion_patterns.present?
        # stack.all(:identifier => search_query, :b
      else

      end
      # search and exclude
    else 
      # exclude
      # Stack.all(:identifier => {:$not => /tes/})
      # Stack.all(:identifier => {:$not => /tes|new one/})
      if exclusion_patterns.present?
        stacks.all(:identifier => {:$not => /#{exclusion_patterns.join('|')}/})
      else
        stacks.all
      end
    end
  end
end
        # sql_pattern = "(#{exclusions_patterns.join('|')})"
        # { :conditions => "identifier #{regex_command} '#{sql_pattern}'" }
      # else
        # {}
      # end


