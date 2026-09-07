# registration e2e Test

require "rails_helper"

RSpec.describe "Registration", type: :system do
  subject { page }

  context "when creating a new user" do
    before do
      visit signup_path

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.create", model: User.model_name.human)
    end

    it { is_expected.to have_content(I18n.t("registrations.create.success")) }
    it { is_expected.to have_content("路人1") }
  end

  # requests test
  context "with POST /signup", type: :request do
    let(:user_params) { { user: { name: "test", email: "test@test.t", password: "test", role: "normal" } } }

    it "increases User" do
      expect {
        post signup_path, params: user_params
      }.to change(User, :count).by(1)
    end

    it "redirects to tasks_path" do
      post signup_path, params: user_params
      expect(response).to redirect_to(tasks_path)
    end
  end
end
