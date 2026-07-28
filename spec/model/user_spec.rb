# user Unit Test

require "rails_helper"

RSpec.describe User do
  describe ".new" do
    subject { User.new(name: user_name, email: email, password: password, role: role) }
      let(:user_name) { "test" }
      let(:email) { "t@t.t" }
      let(:password) { "test" }
      let(:role) { "adminstrator" }
    context "normal input" do
      it { is_expected.to have_attributes(name: "test", email: "t@t.t", password: "test", role: "adminstrator") }
    end
    context "without input email show nil" do
      let(:email) { nil }
      it { is_expected.to have_attributes(email: nil) }
    end
  end
  describe "#role" do
  subject { User.new(role: role) }
    context "administrator" do
      let(:role) { "adminstrator" }
      it { is_expected.to have_attributes(role: "adminstrator") }
    end
    context "normal" do
      let(:role) { "normal" }
      it { is_expected.to have_attributes(role: "normal") }
    end
  end
end
