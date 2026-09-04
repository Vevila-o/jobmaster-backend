# sessions e2e Test

require "rails_helper"
RSpec.describe "Session", type: :system do
  subject { page }

  let(:user) { create(:user) }

  describe "signing" do
    context "when password is correct" do
      before do
        user
        visit new_session_path
        fill_in User.human_attribute_name(:email), with: user.email
        fill_in User.human_attribute_name(:password), with: user.password
        click_button I18n.t("sessions.new.submit")
      end

      it { is_expected.to have_current_path(tasks_path) }
      it { is_expected.to have_content(I18n.t("navigation.auth.welcome", name: user.name)) }
    end

    context "when password is wrong" do
      before do
        user
        visit new_session_path
        fill_in User.human_attribute_name(:email), with: user.email
        fill_in User.human_attribute_name(:password), with: "wrong_password"
        click_button I18n.t("sessions.new.submit")
      end

      it { is_expected.to have_content(I18n.t("sessions.create.fail")) }
      it { is_expected.to have_content(I18n.t("navigation.login")) }
    end


    context "with unknown exist" do
      before do
        user
        visit new_session_path
        fill_in User.human_attribute_name(:email), with: "not_exist_email"
        fill_in User.human_attribute_name(:password), with: user.password
        click_button I18n.t("sessions.new.submit")
      end

      it { is_expected.to have_content(I18n.t("sessions.create.fail")) }
      it { is_expected.to have_content(I18n.t("navigation.login")) }
    end
  end

  describe "signing out" do
    context "when normal situation" do
      before do
        sign_in_as(user)
        click_button I18n.t("navigation.logout")
      end

      it { is_expected.to have_content(I18n.t("navigation.login")) }
      it { is_expected.to have_text(I18n.t("sessions.destroy.success")) }
    end

    context "with no authorize visit tasks_path" do
      before do
        sign_in_as(user)
        click_button I18n.t("navigation.logout")
        visit tasks_path
      end

      it { is_expected.to have_current_path(new_session_path) }
    end
  end
end
