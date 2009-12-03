atom_feed do |feed|
  feed.title(@project.name)
  feed.updated(@stacks.first.updated_at) unless @stacks.empty?

  @stacks.each do |stack|
    feed.entry(stack, :url => project_stack_url(@project, stack)) do |entry|
      entry.title("[#{stack.status} count:#{stack.notifications.size}] #{stack.identifier}")
      entry.content("<pre>#{ActiveSupport::JSON.decode(stack.notifications.last.payload).to_yaml}</pre>")
    end
  end
end