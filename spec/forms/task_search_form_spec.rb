# tasks form uni test
require "rails_helper"

RSpec.describe TaskSearchForm do
  describe "#search" do
    let(:tasks) { FactoryBot.create_list(:task, 10) }
    let(:test_task) { FactoryBot.create(:task, title: "test_task", content: "test_task", end_time: 1.day.from_now, status: "pending") }
    let(:form) { described_class.new(title: title, status: status) }

    before do
        tasks
        test_task
      end

    context "when only search title" do
      let(:title) { "test_task" }
      let(:status) { "" }

      it { expect(form.search).to include(test_task) }
    end

    context "when only search status" do
      let(:title) { nil }
      let(:status) { "pending" }

      it { expect(form.search).to include(test_task) }
    end

    context "when search title and status" do
      let(:title) { "test_task" }
      let(:status) { "pending" }

      it { expect(form.search).to include(test_task) }
    end

    context "when search empty" do
      let(:title) { nil }
      let(:status) { nil }

      it { expect(form.search).to match_array([ test_task ] + tasks) }
    end
  end
end
