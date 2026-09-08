# admin user e2e Test

require "rails_helper"
RSpec.describe "Admin::User", type: :system do
  subject { page }

  let(:user) { User.create(name: "test", email: "t@t.t", password: "test", role: "adminstrator") }
  let(:other_user) { create(:user, role: "normal") }

  context "when editing a user" do
    before do
      user
      sign_in_as(user)
      visit admin_users_path
      click_link I18n.t("action.edit")

      fill_in User.human_attribute_name(:name), with: "路人1"
      fill_in User.human_attribute_name(:email), with: "mob@test.com"
      fill_in User.human_attribute_name(:password), with: "test"
      click_button I18n.t("helpers.submit.update", model: User.model_name.human)
    end

    it do
      expect(page).to have_content(I18n.t("admin.users.update.success"))
    end

    it do
      expect(page).to have_content('路人1')
    end
  end

  context "when deleting a user"  do
    before do
      sign_in_as(user)
      other_user
      visit admin_users_path
      within("tr", text: other_user.email) do
        click_link I18n.t("action.delete")
      end
    end

    it "show success message" do
      expect(page).to have_content(I18n.t("admin.users.destroy.success"))
    end

    it { is_expected.not_to have_content("other_user.name") }
  end

  context "when normal user visits admin_path" do
    let(:normal) { create(:user, role: "normal") }

    before do
      sign_in_as(normal)
      visit admin_users_path
    end

    it "show no_permission message" do
      expect(page).to have_content(I18n.t("navigation.auth.no_permission"))
    end
  end

  # requests test
  context "with PATCH /admin/users/:id", type: :request do
    let(:new_params) { { user: { name: "勇者一" } } }

    context "when updating user" do
      before do
        sign_in_request_as(user)
        user
        patch admin_user_path(user), params: new_params
        user.reload
      end

      it { expect(user).to have_attributes(name: "勇者一") }
    end

    context "when redirecting to admin_user_path" do
      before do
        sign_in_request_as(user)
        patch admin_user_path(user), params: new_params
      end

      it { expect(response).to redirect_to(admin_user_path(user)) }
    end
  end

  context "with DELETE /admin/users/:id", type: :request do
    before do
      sign_in_request_as(user)
      other_user
    end

    it "deletes user from db" do
      expect {
        delete admin_user_path(other_user)
      }.to change(User, :count).by(-1)
    end
  end
end
