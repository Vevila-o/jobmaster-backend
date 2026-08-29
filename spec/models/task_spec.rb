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
    let(:second_task)  { FactoryBot.create(:task, title: "test2", created_at: 4.day.from_now, end_time: 3.days.from_now, priority: "medium") }
    let(:third_task) { FactoryBot.create(:task, title: "test3",  created_at: 5.day.from_now, end_time: 4.days.from_now, priority: "high") }
    let(:first_task) { FactoryBot.create(:task, title: "test1",  created_at: 3.day.from_now, end_time: 5.days.from_now, priority: "high") }


    context "when invalid params URL" do
      before do
        first_task
        second_task
        third_task
      end

      it "falls back to created_at ordering'" do
        invalid_params = described_class.sorted_by(column: "aaa", direction: "asc")
        default = described_class.sorted_by(column: "created_at", direction: "asc")
        expect(invalid_params).to eq(default)
      end
    end
  end
end
