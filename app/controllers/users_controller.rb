class UsersController < ApplicationController
  # 使用者是0 管理者是1

  # 單一使用者
  def show
    @user = User.find_by(id: params[:id])
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
      redirect_to user_path(@user), notice: "新的勇者加入！"
    else
      render :new
    end
  end

  # 編輯
  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.update(user_pramas)
      redirect_to user_path(@user), notice: "變身！"
    else
      render :edit
    end
  end
  # 刪除
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy if @user
    redirect_to users_path, notice: "再見了勇者"
  end

  private
  def user_pramas
    params.require(:user).permit(:name, :email, :role, :password)
  end
end
