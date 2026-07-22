class UsersController < ApplicationController
  # 使用者是0 管理者是1


  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    @users = User.all
  end

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


  private
  def user_pramas
    params.require(:user).permit(:name, :email, :role)
  end
end
