
class TasksController < ApplicationController
  before_action :set_task, only: [ :edit, :update, :destroy ]
  ALLOWED_COLUMNS = [ "end_time", "created_at" ]
  ALLOWED_DIRECTIONS = [ "asc", "desc" ]

  def index
    column = pick_sort(params[:column], allowed: ALLOWED_COLUMNS, default: "created_at")
    direction = pick_sort(params[:direction], allowed: ALLOWED_DIRECTIONS, default: "desc")
    @tasks = Task.sorted_by(column: column, direction: direction)
  end

  # new 不是 create!! 這個是暫時存在記憶體裡面
  def new
    @task = Task.new
  end

  # 因為ruby 4.0 有資安設計 不能直接寫new(params[:task])

  # 新增
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  # 編輯page 跟new一樣不是真的edit
  def edit
  end

  # 編輯
  def update
    if @task.update(task_params)
      flash.now[:notice] = t(".success")
      render partial: "task", locals: { task: @task }
    else
      render :edit, status: :unprocessable_content
    end
  end

  # 刪除
  def destroy
    @task&.destroy
    redirect_to tasks_path, notice: t(".success")
  end

  # private 使用是只要在他之下都會變成private ruby 讀取是只要沒讀到private就會是public 因為要保護變數可是又要用到create
  private
    def set_task
      @task = Task.find_by(id: params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :end_time)
    end
    def pick_sort(input, allowed:, default:)
      allowed.include?(input) ? input : default
    end

  # 修改
end
