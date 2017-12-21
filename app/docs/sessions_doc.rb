module SessionsDoc
  extend Apipie::DSL::Concern

  api :POST, 'auth/sign_in', 'Sign in user'
  error code: 401, desc: 'Unauthorized'
  param :email, String, desc: 'User email', required: true
  param :password, String, desc: 'User password', required: true
  example '
  {
    "data": {
        "id": "18d929c2-766e-4886-ae2c-f67b721466a2",
        "email": "user@user.com",
        "provider": "email",
        "first_name": "Vasya",
        "last_name": "Pupkin",
        "nickname": "Big boss",
        "uid": "user@user.com",
        "lasted_at": "2017-12-31T00:00:00.000Z",
        "image": "https://link-to-file.com",
        "language": "ru"
    }
  }'
  def sign_in_user; end

  api :GET, 'auth/:provider', 'Sign in user from social network'
  example ':redirect, status: 301'
  description 'This action redirects to social network sign in page. Avalible providers are: "facebook", "google_oauth2", "vkontakte", "odnoklassniki"'
  def sign_in_user_from_social_network; end

  api :DELETE, 'auth/sign_out', 'Destroy user session'
  error code: 404, desc: 'Not found'
  example '
  {
    "success": true
  }'
  def sign_out_user; end
end