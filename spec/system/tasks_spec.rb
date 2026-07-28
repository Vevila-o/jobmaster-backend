# user e2e Test

require "rails_helper"
RSpec.describe "Task", type: :system, js: true do
  let!(:task) { Task.create!(title: "test1", content: "test") }
  context "new" do
    before do
      visit tasks_path
      click_link "新增task"

      fill_in "標題", with: "task1"
      fill_in "內容", with: "test"
      click_button "Create Task"
    end

    it { expect(page).to have_content("世界は残酷だ(succed)") }
    it { expect(page).to have_content("task1") }
  end
  context "edit" do
    before do
      visit tasks_path
      click_link "編輯"

      fill_in "標題", with: "task1"
      fill_in "內容", with: "test"
      click_button "Update Task"
    end

    it { expect(page).to have_content("戦おう！(fix)") }
    it { expect(page).to have_content("task1") }
  end
  context "delete" do
    before do
      visit tasks_path
      accept_confirm do
      click_link "刪除"
      end
    end

    it { expect(page).to have_content("自由は海の向こうにある(delete)") }
    it { expect(page).not_to have_content("task1") }
  end
end
