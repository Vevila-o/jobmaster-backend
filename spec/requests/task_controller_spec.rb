  # Tasks request test
  require "rails_helper"

RSpec.describe Task, type: :request do
  # 預設task
  let!(:task) { Task.create!(title: "test1", content: "test") }
  let(:task_params) { { task: { title: "test1", content: "test" } } }
    describe "POST /tasks" do
      it "increases Task" do
        expect {
          post tasks_path, params: task_params
        }.to change(Task, :count).by(1)
      end

      it "redirects to tasks_path" do
        post tasks_path, params: task_params
        expect(response).to redirect_to(tasks_path)
      end
    end
  describe "PATCH /task/:id" do
    let(:update_params) { { task: { title: "nice try", content: "nice" } } }
    context "update Task" do
      before do
        patch task_path(task), params: update_params
        task.reload
      end
      it { expect(task).to have_attributes(title: "nice try", content: "nice") }
    end

    context "shows updated content" do
      before do
        patch task_path(task), params: update_params
      end
      it { expect(response.body).to include("nice try") }
      it { expect(response.body).to include("nice") }
    end
  end
  describe "DELETE /tasks/:id" do
    it "delete task from db" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end
  end
end
