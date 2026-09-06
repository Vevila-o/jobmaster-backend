class RegistrationsController < ApplicationController
  skip_before_action :authorize
  before_action :require_guest

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id unless current_user
      redirect_to tasks_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def require_guest
    if current_user
      flash[:alert] = t("navigation.auth.is_login")
      redirect_to tasks_path
    end
  end
end
