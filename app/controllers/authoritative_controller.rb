class AuthoritativeController < ApplicationController

  before_action :check_groups

  authorize_resource

  def check_groups
    if current_user.groups.blank?
      redirect_to root_url, alert: 'You are not a member of a group, please contact an administrator.'
    end
  end
end