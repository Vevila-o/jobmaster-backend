class TasksController < ApplicationController
  def index
    @tasks = Task.all
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
      redirect_to tasks_path, notice: "世界は残酷だ(succed)"
    else
      render :new
    end
  end

  # 編輯page 跟new一樣不是真的edit
  def edit
    @task = Task.find_by(id: params[:id])
  end

  # 編輯
  def update
    @task = Task.find_by(id: params[:id])

    if @task.update(task_params)
      redirect_to tasks_path, notice: "戦おう！(fix)"
    else
      render :edit
    end
  end

  # 刪除
  def destroy
    @task = Task.find_by(id: params[:id])
    @task.destroy if @task
    redirect_to tasks_path, notice: "自由は海の向こうにある(delete)"
  end

  # private 使用是只要在他之下都會變成private ruby 讀取是只要沒讀到private就會是public 因為要保護變數可是又要用到create
  private
    def task_params
      params.require(:task).permit(:title, :content)
    end

  # 修改
end
