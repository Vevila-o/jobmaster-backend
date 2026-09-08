class User < ApplicationRecord
  enum :role, { "normal": "normal", "adminstrator": "adminstrator" }

  attr_reader :password

  has_many :tasks, dependent: :destroy
  before_update :check_if_last_admin_on_update, if: :role_changed?
  before_destroy :check_if_last_admin_before_destroy, if: :last_and_only_admin?



  validates :name, presence: { message: I18n.t("errors.messages.blank") }

  validates :email, format: { with: /\A[^@]+@[^@]+\z/, allow_blank: true, message: I18n.t("errors.messages.invalid") }, uniqueness: { message: I18n.t("errors.messages.taken"), allow_blank: true }, presence: { message: I18n.t("errors.messages.blank") }

  validates :password, presence: { message: I18n.t("errors.messages.blank") }, on: :create

  attribute :role, :string, default: "normal"

  scope :with_tasks_count, -> { left_joins(:tasks).group(:id).select("users.*, COUNT(tasks.id) AS tasks_count") }


  # 密碼雜湊
  def password=(new_password)
    @password = new_password
    return if @password.blank?
      self.password_digest =BCrypt::Password.create(@password)
  end

  # 密碼驗證
  def check_password?(plain_password)
    return nil unless BCrypt::Password.new(password_digest) == plain_password
    self
  end

  def self.authorize_session(email:, password:)
    find_by(email:)&.check_password?(password)
  end

  private

  def last_and_only_admin?
    adminstrator? && User.adminstrator.count <= 1
  end

  def check_if_last_admin_on_update
    if role_change == [ "adminstrator", "normal" ] && last_and_only_admin?
      errors.add(:base, I18n.t("errors.messages.cannot_change_role"))
      throw :abort
    end
  end

  def check_if_last_admin_before_destroy
    errors.add(:base, I18n.t("errors.messages.cannot_delete"))
    throw :abort
  end
end
