# task e2e Test

require "rails_helper"
RSpec.describe "Task", type: :system, js: true do
  subject { page }
  let!(:task) { Task.create!(title: "test1", content: "test", created_at: Time.zone.now, end_time: 1.day.from_now) }

  context "new" do
    before do
      visit tasks_path
      click_link I18n.t("navigation.new_task_path")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      fill_in Task.human_attribute_name(:end_time), with: Time.zone.parse("2026-08-21 08:00")

      click_button I18n.t("helpers.submit.create", model: Task.model_name.human)
    end

    it { is_expected.to have_content(I18n.t("tasks.create.success")) }
    it { is_expected.to have_content("task1") }
  end

  context "new without end_time" do
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

  context "edit" do
    before do
      visit tasks_path
      click_link I18n.t("action.edit")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      click_button I18n.t("helpers.submit.update", model: Task.model_name.human)
    end
    it { is_expected.to have_content("task1") }
  end

  context "delete" do
    before do
      visit tasks_path
      accept_confirm do
        click_link I18n.t("action.delete")
      end
    end

    it { is_expected.to have_content(I18n.t("tasks.destroy.success")) }
    it { is_expected.not_to have_content("task1") }
  end

  describe "sort" do
    subject { page.text.index("test0") }
    let!(:older_task) { Task.create!(title: "test0", content: "test0", created_at: 1.day.ago, end_time: 2.day.from_now) }

    context "created_asc" do
      before do
        visit tasks_path
        click_link I18n.t("action.created_asc")
        expect(page).to have_current_path(tasks_path(sort: "created_asc"))
      end
      it { is_expected.to be < page.text.index("test1") }
    end

    context "created_desc" do
      before do
        visit tasks_path
        click_link I18n.t("action.created_desc")
      end
      it { expect(page).to have_current_path(tasks_path(sort: "created_desc")) }
      it { is_expected.to be > page.text.index("test1") }
    end
    context "end_time_asc" do
      before do
        visit tasks_path
        click_link I18n.t("action.end_asc")
      end
      it { expect(page).to have_current_path(tasks_path(sort: "end_time_asc")) }
      it { is_expected.to be > page.text.index("test1") }
    end

    context "end_time_desc" do
      before do
        visit tasks_path
        click_link I18n.t("action.end_desc")
        expect(page).to have_current_path(tasks_path(sort: "end_time_desc"))
      end
      it { is_expected.to be < page.text.index("test1") }
    end
  end
end
