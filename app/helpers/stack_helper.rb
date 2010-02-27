module StackHelper

  def filter_options
    {
      "all"      => "show all",
      "default"  => "show all except done",
      "open"     => "show open",
      "progress" => "show in progress",
      "done"     => "show done",
      "include"  => "show excluded"
    }
  end

  def pagination_options
    [50, 100, 200]
  end

end