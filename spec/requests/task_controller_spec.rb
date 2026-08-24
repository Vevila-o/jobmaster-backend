  # Tasks request test
  require "rails_helper"

RSpec.describe Task, type: :request do
  subject(:create_task) { post tasks_path, params: params }

    describe "POST /tasks" do
      context "with valid parameters" do
        let(:params) { { task: { title: "test1", content: "test", end_time: 1.day.from_now } }  }

          it { expect { create_task }.to change(described_class, :count).by(1) }

          it "redirects to tasks_path" do
            create_task
            expect(response).to redirect_to(tasks_path)
          end
      end

      context "when end_time is blank" do
        let(:params) { { task: { title: "test2", content: "nice" } } }

        it "is 422" do
          create_task
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create a task" do
          expect { create_task }.not_to change(described_class, :count)
        end
      end
    end

  describe "PATCH /task/:id" do
    let!(:task) { described_class.create!(title: "test1", content: "test", end_time: 1.day.from_now) }
    let(:update_params) { { task: { title: "nice try", content: "nice" } } }

    context "when task is updated" do
      before do
        patch task_path(task), params: update_params
        task.reload
      end

      it { expect(task).to have_attributes(title: "nice try", content: "nice") }
    end

    context "when rendering the response" do
      before do
        patch task_path(task), params: update_params
      end

      it { expect(response.body).to include("nice try") }
      it { expect(response.body).to include("nice") }
    end
  end

  describe "DELETE /tasks/:id" do
    let!(:task) { described_class.create!(title: "test1", content: "test", end_time: 1.day.from_now) }

    it "delete task from db" do
      expect {
        delete task_path(task)
      }.to change(described_class, :count).by(-1)
    end
  end
end
