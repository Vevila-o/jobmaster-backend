class User < ApplicationRecord
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }
  has_secure_password
  validates :name, presence: true
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }, uniqueness: true
  attribute :role, :string, default: "normal"
end
