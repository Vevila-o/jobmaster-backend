class SessionsController < ApplicationController
  skip_before_action :authorize, only: [ :new, :create ]

  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user && user.check_password?(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: t(".success")
    else
      flash[:alert] = t(".fail")
      render :new, status: :unprocessable_content
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: t(".success")
  end
end
