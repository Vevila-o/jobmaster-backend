  # Users equest test
  require "rails_helper"

RSpec.describe User, type: :request do
  # 預設user
  let!(:user) { described_class.create!(name: "test1", email: "test@t.t", password: "test", role: "normal") }

  describe "POST /users" do
    let(:user_params) { { user: { name: "test", email: "test@test.t", password: "test", role: "normal" } } }

    it "increases User" do
      expect {
        post users_path, params: user_params
      }.to change(described_class, :count).by(1)
    end

    it "redirects to users_path" do
      post users_path, params: user_params
      expect(response).to redirect_to(users_path)
    end
  end

  describe "PATCH /users/:id" do
    let(:new_params) { { user: { name: "勇者一" } } }

    context "when updating user" do
      before do
        patch user_path(user), params: new_params
        user.reload
      end

      it { expect(user).to have_attributes(name: "勇者一") }
    end

    context "when redirecting to user_path" do
      before do
        patch user_path(user), params: new_params
      end

      it { expect(response).to redirect_to(user_path(user)) }
    end
  end

  describe "DELETE /users/:id" do
    it "deletes user from db" do
      expect {
        delete user_path(user)
      }.to change(described_class, :count).by(-1)
    end
  end

  describe "#role" do
    # 目前還沒有登入控制，假定現在都是一般使用者
    let(:role_params) { { user: { role: "adminstrator" } } }

    it "can't be updated to adminstrator" do
      patch user_path(user), params: role_params
      user.reload
      expect(user.role).to eq("normal")
    end
  end
end
