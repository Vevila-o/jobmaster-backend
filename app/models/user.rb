class User < ApplicationRecord
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }

  # 之後會修掉
  has_secure_password

  has_many :tasks, dependent: :restrict_with_error

  validates :name, presence: { message: I18n.t("errors.messages.blank") }

  validates :email, format: { with: /\A[^@]+@[^@]+\z/, allow_blank: true, message: I18n.t("errors.messages.invalid") }, uniqueness: { message: I18n.t("errors.messages.taken"), allow_blank: true }, presence: { message: I18n.t("errors.messages.blank") }

  validates :password, presence: { message: I18n.t("errors.messages.blank") }, on: :create

  attribute :role, :string, default: "normal"
end
