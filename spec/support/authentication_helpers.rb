module AuthenticationHelper
  # system test
  def sign_in_as(user)
    visit new_session_path
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button I18n.t("sessions.new.submit")
  end

  # request test
  def sign_in_request_as(user)
    post session_path, params: { email: user.email, password: user.password }
  end
end
