# User e2e Test

require "rails_helper"
RSpec.describe "User", type: :system do
  subject { page }

  let(:user) { User.create(name: "test", email: "t@t.t", password: "test", role: "normal") }

  context "when creating a new user" do
    before do
      user
      visit users_path
      visit new_user_path

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.create", model: User.model_name.human)
    end

    it { is_expected.to have_content(I18n.t("users.create.success")) }
    it { is_expected.to have_content("路人1") }
  end

  context "when editing a user" do
    before do
      user
      visit users_path
      click_link I18n.t("action.edit")

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.update", model: User.model_name.human)
    end

    it do
      expect(page).to have_content(I18n.t("users.update.success"))
    end

    it do
      expect(page).to have_content('路人1')
    end
  end

  context "when deleting a user"  do
    before do
      user
      visit users_path
        click_link I18n.t("action.delete")
    end

    it { is_expected.to have_content(I18n.t("users.destroy.success")) }
    it { is_expected.not_to have_content("test") }
  end

  # requests test
  context "with POST /users", type: :request do
    let(:user_params) { { user: { name: "test", email: "test@test.t", password: "test", role: "normal" } } }

    it "increases User" do
      expect {
        post users_path, params: user_params
      }.to change(User, :count).by(1)
    end

    it "redirects to users_path" do
      post users_path, params: user_params
      expect(response).to redirect_to(users_path)
    end
  end

  context "with PATCH /users/:id", type: :request do
    let(:new_params) { { user: { name: "勇者一" } } }

    context "when updating user" do
      before do
        user
        patch user_path(user), params: new_params
        user.reload
      end

      it { expect(user).to have_attributes(name: "勇者一") }
    end

    context "when redirecting to user_path" do
      before { patch user_path(user), params: new_params }

      it { expect(response).to redirect_to(user_path(user)) }
    end
  end

  context "with DELETE /users/:id", type: :request do
    before { user }

    it "deletes user from db" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
    end
  end

  context "when updating role", type: :request do
    # 目前還沒有登入控制，假定現在都是一般使用者
    let(:role_params) { { user: { role: "adminstrator" } } }

    before do
      user
      patch user_path(user), params: role_params
      user.reload
    end

    it "can't be updated to adminstrator" do
      expect(user.role).to eq("normal")
    end
  end
end
