class User < ApplicationRecord
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }

  attr_reader :password

  # 密碼雜湊
  def password=(new_password)
    @password = new_password
    return if @password.blank?
      self.password_digest =BCrypt::Password.create(@password)
  end

  # 密碼驗證
  def check_password?(plain_password)
    BCrypt::Password.new(password_digest) == plain_password
  end

  def self.authorize_session(email:, password:)
    user = find_by(email:)
    return nil unless user
    return nil unless user.check_password?(password)
    user
  end


  has_many :tasks, dependent: :restrict_with_error

  validates :name, presence: { message: I18n.t("errors.messages.blank") }

  validates :email, format: { with: /\A[^@]+@[^@]+\z/, allow_blank: true, message: I18n.t("errors.messages.invalid") }, uniqueness: { message: I18n.t("errors.messages.taken"), allow_blank: true }, presence: { message: I18n.t("errors.messages.blank") }

  validates :password, presence: { message: I18n.t("errors.messages.blank") }, on: :create

  attribute :role, :string, default: "normal"
end
