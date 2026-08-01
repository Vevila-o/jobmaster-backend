class Task < ApplicationRecord
  # 需填入標題
  validates_presence_of :title
end
