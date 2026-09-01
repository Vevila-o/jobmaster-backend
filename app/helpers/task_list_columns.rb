module TaskListColumns
  # 任務列表的欄寬。表頭（index）與每一列（_task）共用同一份定義，
  # 避免兩邊各自寫死而對不齊。nil 是操作欄，沒有對應的屬性名稱。
  WIDTHS = {
    id: "w-12 shrink-0",
    title: "w-32 shrink-0",
    content: "flex-1 min-w-0",
    end_time: "w-44 shrink-0",
    status: "w-16 shrink-0",
    priority: "w-16 shrink-0",
    nil => "w-40 shrink-0"
  }.freeze
end
