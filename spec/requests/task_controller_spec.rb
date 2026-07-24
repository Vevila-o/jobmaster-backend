
  require "rails_helper"

RSpec.describe Task, type: :request do
  # 預設task
  let!(:task) { Task.create!(title: "test1", content: "test") }
  let(:task_params) { { task: { title: "test1", content: "test" } } }
    describe "Post Task " do
      it "成功存進資料庫" do
        new_task = Task.new(title: "test1")
        expect(new_task.save).to eq(true)
      end
    it "建立一筆任務" do
      expect {
        post tasks_path, params: task_params
      }.to change(Task, :count).by(1)
    end
    it "導向/tasks" do
      post tasks_path, params: task_params
      expect(response).to redirect_to(tasks_path)
    end
  end
  describe "PATCH Task" do
    let(:update_params) { { task: { title: "nice try", content: "nice" } } }

    it "資料成功修改" do
      # 替換的值
      patch task_path(task), params: update_params
      task.reload
      expect(task.title).to eq("nice try")
      expect(task.content).to eq("nice")
    end

    it "修改成功導向/tasks" do
      # 替換的值
      patch task_path(task), params: update_params
      expect(response).to redirect_to(tasks_path)
    end
  end
  describe "DELETE task" do
    it "從資料庫刪除資料" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end
  end
end
