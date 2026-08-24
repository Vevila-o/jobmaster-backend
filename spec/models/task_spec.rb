# tasks Unit Test

require "rails_helper"

RSpec.describe Task do
  describe ".new" do
    subject { Task.new(title: title, content: content, end_time: end_time) }
        let(:title) { "test1" }
        let(:content) { "test" }
        let(:end_time) { "2026-8-21 08:00" }

    context "input title, content" do
      it { is_expected.to have_attributes(title: "test1", content: "test") }
    end

    context "only content" do
      let(:title) { nil }
      it { is_expected.to have_attributes(content: "test") }
    end

    context "title has value" do
      let(:title) { "test" }
      it { is_expected.to be_valid }
    end

    context "title is empty" do
      let(:title) { nil }
      it { is_expected.to be_invalid }
      it "shows title empty error msg" do
        subject.valid?
        expect(subject.errors[:title]).to be_present
      end
    end
  end

  describe ".create attribute " do
    it "assigns independent titles to separate objects" do
      task1 = Task.create(title: "taskA")
      task2 = Task.create(title: "taskB")
      expect(task1.title).not_to eq(task2.title)
    end
  end
end
