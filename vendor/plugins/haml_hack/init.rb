require 'haml/engine'

module Haml::Precompiler
  alias original_flush_merged_text flush_merged_text

  def flush_merged_text
    @to_merge.each do |item|
      item[1].chomp! unless item[1] == "<!DOCTYPE html>\n"
    end
    original_flush_merged_text
  end
end