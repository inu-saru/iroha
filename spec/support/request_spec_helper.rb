module RequestSpecHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def login_token(user)
    login_params = { user: { email: user.email, password: user.password } }
    post user_session_path, params: login_params
    response.header['Authorization']
  end
end
