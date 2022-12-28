namespace :misc do

  desc "Given a new or edit view filenames replace with a entity links format"
  task :replace_with_entity_links, [:filenames] => [:environment] do |t, args|

    # Using this commend to gather files with old link format
    # FILES=`grep -lER "<%= link_to 'Back to .+'," app/views/* --color=never | tr '\n' ' '`

    filenames = args[:filenames]

    filenames.strip.split(' ').each do |file_name|
      next unless File.exist?(file_name)

      puts "file_name: \"#{file_name}\""
      action = file_name.split('/')[3].split('.')[0]
      entity = file_name.split('/')[2]
      puts "#{entity} #{action}"

      if action == 'new'
      contents =
      """
<h1>New #{entity.singularize.humanize}</h1>
<p>
  <%= render 'application/entity_form_links', entity: @#{entity.singularize} %>
</p>

<%= render 'form' %>
      """
    elsif action == 'edit'
        contents =
        """
<h1>Editing #{entity.singularize.humanize}</h1>
<p>
  <%= render 'application/entity_form_links', entity: @#{entity.singularize} %>
</p>

<%= render 'form' %>
        """
      end

      puts '======================================'
      puts contents
      puts '======================================'

      File.write(file_name, contents)
    end
  end

end
