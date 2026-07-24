# user Unit Test

require "rails_helper"

RSpec.describe User do
  describe "建立" do
    it "一般輸入" do
      user = User.new(name: "test", email: "t@t.t", password: "test", role: "adminstrator")
      expect(user.name).to eq("test")
      expect(user.email).to eq("t@t.t")
      expect(user.password).to eq("test")
      expect(user.role).to eq("adminstrator")
    end
    it "email;沒輸入應為nil" do
      user = User.new
      expect(user.email).to be_nil
    end
  end
  describe "權限運作" do
    it "管理者" do
      user = User.new(role: "adminstrator")
      expect(user.role).to eq("adminstrator")
    end
    it "一般使用者" do
      user = User.new(role: "normal")
      expect(user.role).to eq("normal")
    end
  end
end
