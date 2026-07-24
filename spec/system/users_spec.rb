# user e2e Test

require "rails_helper"
RSpec.describe "使用者user管理", type: :system, js: true do
  let!(:user) { User.create!(name: "test", email: "t@t.t", password: "test") }
  it "新增後列表顯示" do
    visit users_path
    click_link "新增使用者"

    fill_in "名字", with: "路人1"
    fill_in "信箱", with: "mob@test.com"
    fill_in "密碼", with: "test"
    click_button "Create User"

    expect(page).to have_content("新的勇者加入！")
    expect(page).to have_content("路人1")
  end
  it "編輯資料" do
    visit users_path
    click_link "編輯"

    fill_in "名字", with: "路人1"
    fill_in "信箱", with: "mob@test.com"
    fill_in "密碼", with: "test"
    click_button "Update User"
    expect(page).to have_content("變身！")
    expect(page).to have_content("路人1")
  end
  it "刪除資料" do
    visit users_path
    accept_confirm do
      click_link "刪除"
    end
    expect(page).to have_content("再見了勇者")
    expect(page).not_to have_content("test")
  end
end
