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

  describe "#sorted" do
    before do
      FactoryBot.create(:task, title: "test1",  created_at: 5.days.ago, end_time: 5.days.from_now, priority: "low")
      FactoryBot.create(:task, title: "test2", created_at: 4.days.ago, end_time: 3.days.from_now, priority: "medium")
      FactoryBot.create(:task, title: "test3",  created_at: 3.days.ago, end_time: 4.days.from_now, priority: "high")
    end

    context "when invalid params URL" do
      it "falls back to created_at ordering" do
        expect(described_class.sorted_by(column: "aaa", direction: "asc").pluck(:title)).to eq([ "test1", "test2", "test3" ])
      end
    end

    context "when priority sorted_by asc" do
      it { expect(described_class.sorted_by(column: "priority", direction: "asc").pluck(:priority)).to eq([ "high", "medium", "low" ]) }
    end

    context "when priority sorted_by desc" do
      it { expect(described_class.sorted_by(column: "priority", direction: "desc").pluck(:priority)).to eq([ "low", "medium", "high" ]) }
    end
  end
end
