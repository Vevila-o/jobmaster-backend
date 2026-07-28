# User e2e Test

require "rails_helper"
RSpec.describe "User", type: :system, js: true do
  let!(:user) { User.create!(name: "test", email: "t@t.t", password: "test", role: "normal") }
  context "new" do
    before do
      visit users_path
      click_link "新增使用者"

      fill_in "名字", with: "路人1"
      fill_in "信箱", with: "mob@test.com"
      fill_in "密碼", with: "test"
      click_button "Create User"
    end
    it { expect(page).to have_content("新的勇者加入！") }
    it { expect(page).to have_content("路人1") }
  end
  context "edit" do
    before do
      visit users_path
      click_link "編輯"

      fill_in "名字", with: "路人1"
      fill_in "信箱", with: "mob@test.com"
      fill_in "密碼", with: "test"
      click_button "Update User"
    end
    it { expect(page).to have_content("變身！") }
    it { expect(page).to have_content("路人1") }
  end
  context "delete" do
    before do
      visit users_path
      accept_confirm do
      click_link "刪除"
      end
    end
    it { expect(page).to have_content("再見了勇者") }
    it { expect(page).not_to have_content("test") }
  end
end
