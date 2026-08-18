class User < ApplicationRecord
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }
  has_secure_password
  validates :name, presence: { message: I18n.t("errors.messages.blank") }

  validates :email, format: { with: /\A[^@]+@[^@]+\z/, allow_blank: true, message: I18n.t("errors.messages.invalid") }, uniqueness: { message: I18n.t("errors.messages.taken"), allow_blank: true }, presence: { message: I18n.t("errors.messages.blank") }

  validates :password, presence: { message: I18n.t("errors.messages.blank") }, on: :create

  attribute :role, :string, default: "normal"
end
