# user e2e Test

require "rails_helper"
RSpec.describe "tasks管理", type: :system, js: true do
  let!(:task) { Task.create!(title: "test1", content: "test") }
  it "新增後列表顯示" do
    visit tasks_path
    click_link "新增task"

    fill_in "標題", with: "task1"
    fill_in "內容", with: "test"
    click_button "Create Task"

    expect(page).to have_content("世界は残酷だ(succed)")
    expect(page).to have_content("task1")
  end
  it "編輯資料" do
    visit tasks_path
    click_link "編輯"

    fill_in "標題", with: "task1"
    fill_in "內容", with: "test"
    click_button "Update Task"
    expect(page).to have_content("戦おう！(fix)")
    expect(page).to have_content("task1")
  end
  it "刪除資料" do
    visit tasks_path
    accept_confirm do
      click_link "刪除"
    end
    expect(page).to have_content("自由は海の向こうにある(delete)")
    expect(page).not_to have_content("task1")
  end
end
