# task e2e Test

require "rails_helper"
RSpec.describe "Task", type: :system do
  subject { page }

  let(:task) { create(:task, user: user, title: "test1", created_at: Time.zone.now, end_time: 1.day.from_now, status: "pending", priority: "low") }
  let(:user) { User.create(name: "test", email: "t@t.t", password: "test", role: "normal") }

  before { sign_in_as(user) }

  context "when new" do
    before do
      task
      visit new_task_path

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      fill_in Task.human_attribute_name(:end_time), with: Time.zone.parse("2026-08-21 08:00")

      click_button I18n.t("helpers.submit.create", model: Task.model_name.human)
    end

    it { is_expected.to have_content(I18n.t("tasks.create.success")) }
    it { is_expected.to have_content(task.title) }
  end

  context "when new_task without end_time" do
    let(:blank_error) { I18n.t(
      "errors.format",
      attribute: Task.human_attribute_name(:end_time),
      message: I18n.t("errors.messages.blank"))}

    before do
      visit tasks_path
      click_link I18n.t("navigation.new_task_path")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      click_button I18n.t("helpers.submit.create", model: Task.model_name.human)
    end

    it { is_expected.to have_content(blank_error) }
  end

  context "when edit task" do
    before do
      task
      visit tasks_path
      click_link I18n.t("action.edit")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "update_content"
      click_button I18n.t("helpers.submit.update", model: Task.model_name.human)
    end

    it { is_expected.to have_text("task1") }
    it { is_expected.not_to have_content(task.title) }
    it { is_expected.to have_text("update_content") }
  end


  context "when delete task" do
    before do
      task
        visit tasks_path
        click_link I18n.t("action.delete")
    end

    it { is_expected.to have_content(I18n.t("tasks.destroy.success")) }
    it { is_expected.not_to have_content(task.title) }
  end

  describe "sort" do
    let(:older_task) { create(:task, user: user, title: "test0", created_at: 1.day.ago, end_time: 2.days.from_now, priority: "low") }

    before do
      task
      older_task
      visit tasks_path
    end

    context "when sorted by created_asc" do
      before do
        click_link I18n.t("action.created_asc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "created_at", direction: "asc")) }
      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ older_task.title, task.title ]) }
    end

    context "when sorted by created_desc" do
      before do
        click_link I18n.t("action.created_desc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "created_at", direction: "desc")) }
      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ task.title, older_task.title ]) }
    end

    context "when sorted by end_time_asc" do
      before do
        click_link I18n.t("action.end_asc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "end_time", direction: "asc")) }
      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ task.title, older_task.title ]) }
    end

    context "when sorted by end_time_desc" do
      before do
        click_link I18n.t("action.end_desc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "end_time", direction: "desc")) }

      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ older_task.title, task.title ]) }
    end
  end

  describe "priority sort" do
    let(:medium_task)  { create(:task, user: user, priority: "medium") }
    let(:high_task) { create(:task, user: user, priority: "high") }

    before do
      task
      medium_task
      high_task
    end

    context "when sorted by priority_asc" do
      before do
        visit tasks_path
        click_link I18n.t("action.priority_asc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "priority", direction: "asc")) }

      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ high_task.title, medium_task.title, task.title ]) }
    end

    context "when sorted by priority_desc" do
      before do
        visit tasks_path
        click_link I18n.t("action.priority_desc")
      end

      it { is_expected.to have_current_path(tasks_path(column: "priority", direction: "desc")) }

      it { expect(all("turbo-frame td.task-title").map(&:text)).to eq([ task.title, medium_task.title, high_task.title ]) }
    end
  end

  describe "#pagy" do
    let(:total) { 15 }
    let(:per_page) { Pagy::OPTIONS[:limit] }

    before do
      create_list(:task, total, user: user)
      visit tasks_path
    end

    context "when tasks on first page" do
      it { is_expected.to have_css("turbo-frame", count: per_page) }
    end

    context "when move to next page" do
      before do
        find("nav.pagy a[rel='next']:last-child").click
      end

      it { is_expected.to have_css("turbo-frame", count: total - per_page) }
    end

    context "when move to next page with search condition" do
      let(:target) { 10 }

      before do
        create_list(:task, target, user: user, title: "test_target")
        fill_in Task.human_attribute_name(:title), with: "test_target"
        click_button I18n.t("action.search")
        find("nav.pagy a[rel='next']:last-child").click
      end

      it { is_expected.to have_css("turbo-frame", count: target - per_page) }
    end
  end

  describe "search" do
    let(:test_task) { create(:task, user: user, title: "test_task", status: "in_progress") }

    before do
      task
      test_task
      visit tasks_path
    end

    context "when search title and status" do
      before do
        fill_in Task.human_attribute_name(:title), with: "test_task"
        select I18n.t("activerecord.attributes.task.statuses.in_progress"), from: Task.human_attribute_name(:status)
        click_button I18n.t("action.search")
      end

      it { is_expected.to have_content("test_task") }
      it { is_expected.not_to have_content("test1") }
    end


    context "when only search title" do
      before do
        fill_in Task.human_attribute_name(:title), with: "test_task"
        click_button I18n.t("action.search")
      end

      it { is_expected.to have_content("test_task") }
      it { is_expected.not_to have_content("test1") }
    end

    context "when only search status" do
      before do
        select I18n.t("activerecord.attributes.task.statuses.in_progress"), from: Task.human_attribute_name(:status)
        click_button I18n.t("action.search")
      end

      it { is_expected.to have_content("test_task") }
      it { is_expected.not_to have_content("test1") }
    end

    context "when search empty" do
      before do
        fill_in Task.human_attribute_name(:title), with: nil
        select "", from: Task.human_attribute_name(:status)
        click_button I18n.t("action.search")
      end

      it { is_expected.to have_content("test_task").and have_content("test1") }
    end
  end



  # requests test
  context "with POST /tasks", type: :request do
    subject(:create_task) { post tasks_path, params: params }

    before { sign_in_request_as(user) }

    context "with valid parameters" do
    let(:params) { { task: { title: "test1", content: "test", end_time: 1.day.from_now } } }

    before { sign_in_request_as(user) }

      it { expect { create_task }.to change(Task, :count).by(1) }

      it "redirects to tasks_path" do
        create_task
        expect(response).to redirect_to(tasks_path)
      end
    end

    context "when end_time is blank" do
      before { sign_in_request_as(user) }

      let(:params) { { task: { title: "test2", content: "nice" } } }

      it "is 422" do
        create_task
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not create a task" do
        expect { create_task }.not_to change(Task, :count)
      end
    end
  end

  context "with PATCH /task/:id", type: :request do
    let(:update_params) { { task: { title: "nice try", content: "nice" } } }

    before { sign_in_request_as(user) }

    context "when task is updated" do
      before do
        patch task_path(task), params: update_params
        task.reload
      end

      it { expect(task).to have_attributes(title: "nice try", content: "nice") }
    end
  end

  context "with DELETE /tasks/:id", type: :request do
    before do
      task
      sign_in_request_as(user)
    end

    it "delete task from db" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end
  end
end
