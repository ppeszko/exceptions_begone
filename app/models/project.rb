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
    elsif filter.present?
      if exclusion_patterns.present?
        stacks.all({:identifier => {:$not => /#{exclusion_patterns.join('|')}/}}.merge(Stack.condition_for_filter(filter)))
      else
        stacks.all(Stack.condition_for_filter(filter))
      end
    else
      stacks.all()
    end
  end
end
