# User e2e Test

require "rails_helper"
RSpec.describe "User", type: :system, js: true do
  subject { page }
  let!(:user) { User.create!(name: "test", email: "t@t.t", password: "test", role: "normal") }

  context "new" do
    before do
      visit users_path
      click_link I18n.t("navigation.new_user_path")

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.create", model: User.model_name.human)
    end
    it { is_expected.to have_content(I18n.t("users.create.success")) }
    it { is_expected.to have_content("路人1") }
  end

  context "edit" do
    before do
      visit users_path
      click_link I18n.t("action.edit")

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.update", model: User.model_name.human)
    end
    it { is_expected.to have_content(I18n.t("users.update.success")) }
    it { is_expected.to have_content("路人1") }
  end

  context "delete" do
    before do
      visit users_path
      accept_confirm do
        click_link I18n.t("action.delete")
      end
    end
    it { is_expected.to have_content(I18n.t("users.destroy.success")) }
    it { is_expected.not_to have_content("test") }
  end
end
