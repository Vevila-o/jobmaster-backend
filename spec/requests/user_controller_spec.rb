
  require "rails_helper"

RSpec.describe User, type: :request do
  # 預設user
  let!(:user) { User.create!(name: "test1", email: "test@t.t", password: "test", role: "normal") }
  let(:user_params) { { user: { name: "test1", email: "test@t.t", password: "test", role: "normal" } } }
  describe "Post User " do
    it "成功存進資料庫" do
      new_user = User.new(name: "test1")
      expect(new_user.save).to eq(true)
    end
    it "建立一位使用者" do
      expect {
        post users_path, params: user_params
      }.to change(User, :count).by(1)
    end
    it "導向/users" do
      post users_path, params: user_params
      expect(response).to redirect_to(users_path)
    end
  end
  describe "PATCH User" do
    it "資料成功修改" do
      new_params = { user: { name: "勇者一" } }
      patch user_path(user), params: new_params
      user.reload
      expect(user.name).to eq("勇者一")
    end

    it "修改成功導向/users" do
      user_params = { user: { name: "勇者ㄧ" } }
      patch user_path(user), params: user_params
      expect(response).to redirect_to(user_path(user))
    end
  end
  describe "DELETE user" do
    it "從資料庫刪除資料" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
    end
  end

  describe "權限" do
    # 目前還沒有登入控制，假定現在都是一般使用者
    it "一般使用者編輯 role 不更動" do
    user_params = { user: { role: "adminstrator" } }
    patch user_path(user), params: user_params
    user.reload
    expect(user.role).to eq("normal")
    end
  end
end
