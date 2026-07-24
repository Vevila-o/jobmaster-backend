class User < ApplicationRecord
  # 原本設定存入是int，pr建議修正後存入string
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }
end
