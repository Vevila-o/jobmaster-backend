class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  # new 不是 create!! 這個是暫時存在記憶體裡面
  def new
    @task = Task.new
  end

  # 因為ruby 4.0 有資安設計 不能直接寫new(params[:task])

  private
  def task_params
    params.require(:task).permit(:title, :content)
  end


  # 新增
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: "すごい！成功した!"
    
    else
      render :new
    end
  end


  # 修改



end
