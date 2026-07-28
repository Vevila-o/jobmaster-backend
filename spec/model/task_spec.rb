# tasks Unit Test

require "rails_helper"

RSpec.describe Task do
  describe ".new" do
    subject { Task.new(title: title, content: content) }
        let(:title) { "test1" }
        let(:content) { "test" }
    context "input title, content" do
      it { is_expected.to have_attributes(title: "test1", content: "test") }
    end
    context "no input title" do
      let(:title) { nil }
      let(:content) { nil }
      it { is_expected.to have_attributes(title: nil) }
    end

    context "only content" do
      let(:title) { nil }
      it { is_expected.to have_attributes(content: "test") }
    end
  end
  describe ".create" do
    it "creates independent records with different titles" do
      task1 = Task.create(title: "taskA")
      task2 = Task.create(title: "taskB")
      expect(task1.title).not_to eq(task2.title)
    end
  end
end
