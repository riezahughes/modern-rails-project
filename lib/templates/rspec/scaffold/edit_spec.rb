require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= table_name %>/edit", type: :view do
  before(:each) do
    @<%= file_name %> = assign(:<%= file_name %>, <%= class_name %>.create!(<%= '))' if output_attributes.empty? %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= attribute.default.inspect %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    ))\n" -%>
  end

  it "renders the edit <%= file_name %> form" do
    render

    assert_select "form[action=?][method=?]", <%= file_name %>_path(@<%= file_name %>), "post" do
<% for attribute in output_attributes -%>
      <%- name = attribute.respond_to?(:column_name) ? attribute.column_name : attribute.name %>
      assert_select "<%= attribute.input_type -%>#<%= file_name %>_<%= name %>[name=?]", "<%= file_name %>[<%= name %>]"
<% end -%>
    end
  end
end
