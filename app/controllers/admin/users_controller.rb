module Admin
  class UsersController < BaseController
    before_action :set_user, only: [ :show, :edit, :update, :destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to admin_users_path, alert: t("errors.messages.invalid") }

    # 全部使用者
    def index
      @users = User.with_tasks_count
    end

    # 單一使用者
    def show
    end

    # 新增
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: t(".success")
      else
        render :new, status: :unprocessable_content
      end
    end

    # 編輯
    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: t(".success")
      else
        render :edit, status: :unprocessable_content
      end
    end

    def show
      @tasks = @user.tasks
    end

    # 刪除
    def destroy
      @user&.destroy
      redirect_to admin_users_path, notice: t(".success")
    end

    private
      def set_user
        @user = User.with_tasks_count.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :role)
      end
  end
end
