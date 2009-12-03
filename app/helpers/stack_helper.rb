module StackHelper
  def filter_options
    {
      "show all" => "all",
      "show done" => "done",
      "hide done" => "default",
      "show incoming" => "incoming",
      "show in_progress" => "in_progress",
      "show excluded" => "include"
    }
  end
end
