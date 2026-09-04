class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pagy::Method
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pagy::RangeError, with: -> { redirect_to tasks_path(params.permit(:column, :direction, task_search_form: [ :title, :status ])) }

  before_action :authorize
  helper_method :current_user

  private
  def authorize
    unless current_user
      flash[:alert] = t("navigation.auth.no_login")
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
