module UserSettingsDoc
  extend Apipie::DSL::Concern

  api :PUT, 'api/v3/update_personal_info', 'Update user personal info'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :user, Hash, required: true do
    param :first_name, String, desc: 'User first name'
    param :last_name, String, desc: 'User last name'
    param :nickname, String, desc: 'User nickname'
    param :phone, String, desc: 'User phone'
    param :phone_2, String, desc: 'User second phone'
    param :skype, String, desc: 'User skype'
    param :country, String, desc: 'User nickname'
    param :city, String, desc: 'User nickname'
    param :status, String, desc: 'User status'
  end
  example '
  {
    "data": {
        "user": {
            "id": "35356bb2-21e3-48c3-8b9b-5a0d6cdd3072",
            "first_name": "Vasya",
            "last_name": "Pupkin",
            "nickname": "Strong man",
            "image": "https://link-to-file.com",
            "email": "vasya@pupkin.com",
            "phone": "380671234567",
            "phone_2": null,
            "skype": "vasya_man",
            "country": "Surinam",
            "city": "Paramaribo ",
            "status": "I am cool"
        }
    }
  }'
  def update_personal_info; end

  api :PUT, 'api/v3/update_privacy', 'Update user privacy settings'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :user, Hash, required: true do
    param :show_phones, ['"all", "followers" "hidden"'], desc: 'User phones privacy'
    param :show_skype, ['"all", "followers" "hidden"'], desc: 'User skype privacy'
    param :show_country, ['"all", "followers" "hidden"'], desc: 'User country privacy'
    param :show_city, ['"all", "followers" "hidden"'], desc: 'User city privacy'
    param :show_status, ['"all", "followers" "hidden"'], desc: 'User status privacy'
  end
  example ':no_content, status: 200'
  def update_privacy; end

  api :PUT, 'api/v3/update_language', 'Update app language'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :language, ['"en", "ru" "es" "ar" "zh"'], desc: 'Application language', required: true
  example ':no_content, status: 200'
  def update_language; end

  api :GET, 'api/v3/get_user_info/:user_id', 'Get user info'
  error code: 404, desc: 'User not found'
  example '
  {
    "data": {
        "user_info": {
            "id": "35356bb2-21e3-48c3-8b9b-5a0d6cdd3072",
            "first_name": "Vasya",
            "last_name": "Pupkin",
            "nickname": "Strong man",
            "image": "https://link-to-file.com",
            "email": "vasya@pupkin.com",
            "phone": "380671234567",
            "phone_2": null,
            "skype": "vasya_man",
            "country": "Surinam",
            "city": "Paramaribo ",
            "status": "I am cool"
        }
    }
  }'
  def get_user_info; end
end