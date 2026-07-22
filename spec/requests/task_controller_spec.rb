
  require "rails_helper"

RSpec.describe Task, type: :request do
    describe "Post Task " do
        it "成功存進資料庫" do
      task = Task.new(title: "test1")
      expect(task.save).to eq(true)
    end
    it "建立一筆任務" do
      valid_params = { task: { title: "test1", content: "test" } }
      expect {
        post tasks_path, params: valid_params
    }.to change(Task, :count).by(1)
    end
    it "導向/tasks" do
      valid_params = { task: { title: "test1", content: "test" } }
      post tasks_path, params: valid_params
      expect(response).to redirect_to(tasks_path)
    end
  end
  describe "PATCH Task" do
    it "資料成功修改" do
      task = Task.create!(title: "test1", content: "test")
      # 替換的值
      task_params =  { task: { title: "nice try", content: "nice" } }
      patch task_path(task), params: task_params
      task.reload
      expect(task.title).to eq("nice try")
      expect(task.content).to eq("nice")
    end

    it "修改成功導向/tasks" do
      task = Task.create!(title: "test1", content: "test")
      # 替換的值
      patch task_path(task), params: { task: {  title: "nice try", content: "nice" } }
      expect(response).to redirect_to(tasks_path)
    end

    describe "DELETE task" do
      it "從資料庫刪除資料" do
        task = Task.create!(title: "test1", content: "test")
        expect {
          delete task_path(task)
        }.to change(Task, :count).by(-1)
      end
    end
  end
end
