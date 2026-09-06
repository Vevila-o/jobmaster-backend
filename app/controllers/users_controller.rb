class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  skip_before_action :authorize, only: [ :new, :create ]
  before_action :require_guest, only: [ :new, :create ]


  # 單一使用者
  def show
  end

  # 全部使用者
  def index
    @users = User.all
  end

  # 新增
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

  # 編輯
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end
  # 刪除
  def destroy
    if @user&.destroy
      redirect_to users_path, notice: t(".success")
    else
      redirect_to users_path, alert: t(".user_blank")
    end
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def require_guest
    if current_user
      flash[:alert] = t("navigation.auth.is_login")
      redirect_to tasks_path
    end
  end


  # 等登入機制做好後再補上
  # def admin_user_params
  #   params.require(:user).permit(:name, :email, :role)
  # end
end
