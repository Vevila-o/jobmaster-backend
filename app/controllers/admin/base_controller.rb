
class Admin::BaseController < ApplicationController
  before_action :check_admin

  def check_admin
    unless current_user.adminstrator?
      redirect_to tasks_path, alert: t("navigation.auth.no_permission")
    end
  end
end
