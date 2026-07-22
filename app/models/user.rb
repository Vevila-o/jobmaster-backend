class User < ApplicationRecord
  enum :role, { "一般使用者": 0, "管理者": 1 }
end
