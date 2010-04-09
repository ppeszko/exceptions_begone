class Project
  include MongoMapper::Document

  key :name
  key :description
  key :warning_threshold
  timestamps!

  many :stacks
  many :exclusions

  def find_stacks(search_query, filter, order)
    exclusion_patterns = exclusions.all(:enabled => true).map(&:pattern)

    if search_query
      stacks.all(:identifier => /#{search_query}/)
    elsif exclusion_patterns.present?  
      stacks.all(:identifier => {:$not => /#{exclusion_patterns.join('|')}/})
    elsif filter.present?
      stacks.all(Stack.condition_for_filter(filter))
    else
      stacks.all()
    end
  end
end
        # sql_pattern = "(#{exclusions_patterns.join('|')})"
        # { :conditions => "identifier #{regex_command} '#{sql_pattern}'" }
      # else
        # {}
      # end


