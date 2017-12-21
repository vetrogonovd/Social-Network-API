module RegistrationsDoc
  extend Apipie::DSL::Concern

  api :POST, 'auth', 'Create new user'
  error code: 422, desc: 'Unprocessable entity'
  param :email, String, desc: 'User email', required: true
  param :password, String, desc: 'User password', required: true
  param :password_confirmation, String, desc: 'Password confirmation', required: true
  param :first_name, String, desc: 'User first name'
  param :last_name, String, desc: 'User last name'
  param :phone, String, desc: 'User phone'
  param :country, String, desc: 'User country'
  example '
  {
    "data": {
        "id": "27e0fff7-f254-489d-94c0-bde589ca520e",
        "provider": "email",
        "uid": "user@user.com",
        "lasted_at": null,
        "first_name": "Vasya",
        "last_name": "Pupkin",
        "nickname": null,
        "image": null,
        "email": "user@user.com",
        "created_at": "2017-12-31T00:00:00.000Z",
        "updated_at": "2017-12-31T00:00:00.000Z"
    }
  }'
  def create_user; end

  api :GET, 'auth/:provider', 'Create new user from social network'
  example ':redirect, status: 301'
  description 'This action redirects to social network sign in page. Avalible providers are: "facebook", "google_oauth2", "vkontakte", "odnoklassniki"'
  def create_user_from_social_network; end
end