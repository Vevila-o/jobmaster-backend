# tasks Unit Test

require "rails_helper"

RSpec.describe Task do
  describe "建立" do
    it "標題內容都輸入" do
      task = Task.new(title: "test1", content: "test")
      expect(task.title).to eq("test1")
      expect(task.content).to eq("test")
    end
    it "標題沒輸入應為nil" do
      task = Task.new
      expect(task.title).to be_nil
    end
    it "僅輸入內容" do
      task = Task.new(content: "test")
      expect(task.content).to eq("test")
    end
    it "新任務A不出現其他任務中" do
      task1 = Task.create(title: "taskA")
      task2 = Task.create(title: "taskB")
      expect(task1.title).not_to eq(task2.title)
    end
  end
end
