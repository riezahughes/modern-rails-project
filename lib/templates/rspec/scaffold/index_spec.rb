require 'rails_helper'
require 'will_paginate/array'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/index", <%= type_metatag(:view) %> do
  let(:<%= table_name %>) {[
<% [1,2].each_with_index do |id, model_index| -%>
      <%= class_name %>.create!(<%= output_attributes.empty? ? (model_index == 1 ? ')' : '),') : '' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
        :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
      <%= model_index == 1 ? ')' : '),' %>
<% end -%>
<% end -%>
    ]}

  it "renders a list of <%= ns_table_name %>" do
    @test_user = User.find_by_username('test') || FactoryGirl.create(:user)
    sign_in @test_user

    assign(:search, <%= class_name %>.ransack(params[:q]))
    assign(:<%= table_name %>, <%= table_name %>.paginate(per_page: 2))

    render
<% for attribute in output_attributes -%>
    assert_select "tr>td", :text => <%= value_for(attribute) %>.to_s, :count => 2
<% end -%>
  end
end
