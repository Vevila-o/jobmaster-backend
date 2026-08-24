class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
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
    @user = User.new(user_pramas)

    if @user.save
      redirect_to users_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  # 編輯
  def edit
  end

  def update
    if @user.update(user_pramas)
      redirect_to user_path(@user), notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end
  # 刪除
  def destroy
    @user&.destroy
    redirect_to users_path, notice: t(".success")
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
  end
  def user_pramas
    params.require(:user).permit(:name, :email, :password)
  end

  # 等登入機制做好後再補上
  # def admin_user_pramas
  #   params.require(:user).permit(:name, :email, :role)
  # end
end
