Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           info_fields: 'email, first_name, last_name'

  provider :vkontakte, ENV['VK_KEY'], ENV['VK_SECRET'],
           scope: 'friends,audio,photos,email',
           lang: 'en',
           image_size: 'original'
  
  provider :odnoklassniki, ENV['ODNOKLASSNIKI_ID'], ENV['ODNOKLASSNIKI_SECRET'],
           public_key: ENV['ODNOKLASSNIKI_PUBLIC']

  provider :google_oauth2, ENV['GOOGLE_ID'], ENV['GOOGLE_SECRET'],
           verify_iss: false
end