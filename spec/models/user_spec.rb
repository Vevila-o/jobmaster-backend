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

      context "name is blank" do
        let(:user_name) { nil }
        it { is_expected.to be_invalid }
        it "shows name empty error msg" do
          subject.valid?
          expect(subject.errors[:name]).to be_present
        end
      end

      context "password is blank" do
        let(:password) { nil }
        it { is_expected.to be_invalid }
        it "shows password empty error msg" do
          subject.valid?
          expect(subject.errors[:password]).to be_present
        end
      end
  end

  describe "#email" do
    subject { User.new(name: "test", email: email, password: "test", role: "normal") }

    context "is blank" do
      let(:email) { nil }
      it { is_expected.to be_invalid }
      it "shows email empty error msg" do
        subject.valid?
        expect(subject.errors[:email]).to be_present
      end
    end
    context "format is invaild" do
      let(:email) { "@t.t" }
      it { is_expected.to be_invalid }
      it "shows email empty error msg" do
        subject.valid?
        expect(subject.errors[:email]).to be_present
      end
    end

    context "is taken" do
      let(:email) { "t@t.t" }
      let!(:second) { User.create!(name: "test2", email: "t@t.t", password: "test") }
      it { is_expected.to be_invalid }
      it "shows email taken error msg" do
        subject.valid?
        expect(subject.errors[:email]).to be_present
      end
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
