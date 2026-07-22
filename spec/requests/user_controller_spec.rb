
  require "rails_helper"

RSpec.describe User, type: :request do
    describe "Post User " do
        it "成功存進資料庫" do
      user = User.new(name: "test1")
      expect(user.save).to eq(true)
    end
    it "建立一位使用者" do
      valid_params = { user: { name: "test1", email: "test@t.t", password: "test", role: "管理者" } }
      expect {
        post users_path, params: valid_params
    }.to change(User, :count).by(1)
    end
    it "導向/users" do
      valid_params = { user: { name: "test1", email: "test@t.t", password: "test", role: "管理者" } }
      post users_path, params: valid_params
      expect(response).to redirect_to(users_path)
    end
  end
  describe "PATCH User" do
    it "資料成功修改" do
      user = User.create!(name: "test1", email: "test@t.t", password: "test", role: "管理者")
      user_params = { user: { name: "勇者一" } }
      patch user_path(user), params: user_params
      user.reload
      expect(user.name).to eq("勇者一")
    end

    it "修改成功導向/users" do
      user = User.create!(name: "test1", email: "test@t.t", password: "test", role: "管理者")
      user_params = { user: { name: "勇者ㄧ" } }
      patch user_path(user), params: user_params
      expect(response).to redirect_to(user_path(user))
    end

    describe "DELETE user" do
      it "從資料庫刪除資料" do
        user = User.create!(name: "test1", email: "test@t.t", password: "test", role: "管理者")
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)
      end
    end

    describe "權限" do
      # 目前還沒有登入控制，假定現在都是一般使用者
      it "一般使用者編輯 role 不更動" do
      user = User.create!(name: "test1", email: "test@t.t", password: "test", role: "一般使用者")
      user_params = { user: { role: "管理者" } }
      patch user_path(user), params: user_params
      user.reload
      expect(user.role).to eq("一般使用者")
      end
    end
  end
end
