# user Unit Test

require "rails_helper"

RSpec.describe User do
  describe ".new" do
    subject (:user) { described_class.new(name: user_name, email: email, password: password, role: role) }

      let(:user_name) { "test" }
      let(:email) { "t@t.t" }
      let(:password) { "test" }
      let(:role) { "adminstrator" }

      context "with valid attributes" do
        it { is_expected.to have_attributes(name: "test", email: "t@t.t", password: "test", role: "adminstrator") }
      end

      context "when name is blank" do
        let(:user_name) { nil }

        it { is_expected.to be_invalid }

        it "shows name empty error msg" do
          user.valid?
          expect(user.errors[:name]).to be_present
        end
      end

      context "when password is blank" do
        let(:password) { nil }

        it { is_expected.to be_invalid }

        it "shows password empty error msg" do
          user.valid?
          expect(user.errors[:password]).to be_present
        end
      end
  end

  describe "#email" do
    subject(:test_user) { described_class.new(name: "test", email: email, password: "test", role: "normal") }

    context "when email is blank" do
      let(:email) { nil }

      it { is_expected.to be_invalid }

      it "shows email empty error msg" do
        test_user.valid?
        expect(test_user.errors[:email]).to be_present
      end
    end

    context "when email format is invalid" do
      let(:email) { "@t.t" }

      it { is_expected.to be_invalid }

      it "shows email empty error msg" do
        test_user.valid?
        expect(test_user.errors[:email]).to be_present
      end
    end

    context "when email is already taken" do
      let(:email) { "t@t.t" }
      let(:second) { described_class.create(name: "test2", email: "t@t.t", password: "test") }

      before do
        test_user
        second
      end

      it { is_expected.to be_invalid }

      it "shows email taken error msg" do
        test_user.valid?
        expect(test_user.errors[:email]).to be_present
      end
    end
  end

  describe "#role" do
    subject { described_class.new(role: role) }

      context "when role is administrator" do
        let(:role) { "adminstrator" }

        it { is_expected.to have_attributes(role: "adminstrator") }
      end

      context "when role is normal" do
        let(:role) { "normal" }

        it { is_expected.to have_attributes(role: "normal") }
      end
  end
end
