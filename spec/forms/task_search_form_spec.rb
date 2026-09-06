# tasks form uni test
require "rails_helper"

RSpec.describe TaskSearchForm do
  describe "#search" do
    let(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.create(:task, user: user, title: "first_task", content: "task", end_time: 2.day.from_now, status: "in_progress") }
    let(:test_task) { FactoryBot.create(:task, user: user, title: "test_task", content: "test_task", end_time: 1.day.from_now, status: "pending") }
    let(:form) { described_class.new(user: user, title: title, status: status) }

    before do
        task
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

    context "when search fill empty" do
      let(:title) { nil }
      let(:status) { nil }

      it { expect(form.search).to include(test_task, task) }
    end
  end
end
