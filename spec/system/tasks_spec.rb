# task e2e Test

require "rails_helper"
RSpec.describe "Task", type: :system, js: true do
  let!(:task) { Task.create!(title: "test1", content: "test", created_at: Time.zone.now) }
  context "new" do
    before do
      visit tasks_path
      click_link I18n.t("path.new_task_path")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      click_button I18n.t("helpers.submit.create", model: Task.model_name.human)
    end

    it { expect(page).to have_content(I18n.t("task.flash.new_succeed")) }
    it { expect(page).to have_content("task1") }
  end
  context "edit" do
    before do
      visit tasks_path
      click_link I18n.t("action.edit")

      fill_in Task.human_attribute_name(:title), with: "task1"
      fill_in Task.human_attribute_name(:content), with: "test"
      click_button I18n.t("helpers.submit.update", model: Task.model_name.human)
    end

    it { expect(page).to have_content(I18n.t("task.flash.edit_succeed")) }
    it { expect(page).to have_content("task1") }
  end
  context "delete" do
    before do
      visit tasks_path
      accept_confirm do
        click_link I18n.t("action.delete")
      end
    end

    it { expect(page).to have_content(I18n.t("task.flash.delete_succeed")) }
    it { expect(page).not_to have_content("task1") }
  end
  describe "sort" do
  let!(:older_task) { Task.create!(title: "test0", content: "test0", created_at: 1.day.ago) }
    context "created_asc" do
      before do
        visit tasks_path
        click_link I18n.t("action.created_asc")
        expect(page).to have_current_path(tasks_path(sort: "created_asc"))
      end
      it { expect(page.text.index("test0")).to be < page.text.index("test1") }
    end

    context "create_desc" do
      before do
        visit tasks_path
        click_link I18n.t("action.created_desc")
        expect(page).to have_current_path(tasks_path(sort: "created_desc"))
      end
      it { expect(page.text.index("test0")).to be > page.text.index("test1") }
    end
  end
end
