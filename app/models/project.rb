class Project
  include MongoMapper::Document

  key :name
  key :description
  key :warning_threshold, Integer, :default => 10
  timestamps!

  many :stacks
  many :exclusions

  def find_stacks(search_query, filter, options = {})
    exclusion_patterns = exclusions.all(:enabled => true).map(&:pattern)

    if search_query
      stacks.all({:identifier => /#{search_query}/}.merge(options))
    elsif filter.present?
      if exclusion_patterns.present?
        stacks.all({:identifier => {:$not => /#{exclusion_patterns.join('|')}/}}.merge(Stack.condition_for_filter(filter)).merge(options))
      else
        stacks.all(Stack.condition_for_filter(filter).merge(options))
      end
    else
      stacks.all(options)
    end
  end
end
