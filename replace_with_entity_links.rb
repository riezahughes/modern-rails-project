file_name = ARGV[0]
action = file_name.split('/')[3].split('.')[0]
entity = file_name.split('/')[2]
puts "#{entity} #{action}"

puts '======================================'
if action == 'new'
contents =
"""
  <h1>New #{entity.humanize}</h1>
  <p>
    <%= render 'application/entity_form_links', entity: @#{entity} %>
  </p>

  <%= render 'form' %>
"""
else
end

puts contents
puts '======================================'
