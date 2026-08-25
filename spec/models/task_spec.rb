# tasks Unit Test

require "rails_helper"

RSpec.describe Task do
  describe ".new" do
    subject (:task) { FactoryBot.build(:task, title: title, content: content, end_time: end_time) }

      let(:title) { "test1" }
      let(:content) { "test" }
      let(:end_time) { "2026-8-21 08:00" }

    context "when title and content are given" do
      it { is_expected.to have_attributes(title: "test1", content: "test") }
    end

    context "without title" do
      let(:title) { nil }

      it { is_expected.to have_attributes(content: "test") }
    end

    context "when title is present" do
      let(:title) { "test" }

      it { is_expected.to be_valid }
    end

    context "when title is blank" do
      let(:title) { nil }

      it { is_expected.to be_invalid }

      it "shows title empty error msg" do
        task.valid?
          expect(task.errors.of_kind?(:title, :blank)).to be true
      end
    end
  end
end
