json.data do
  json.user_info do
    json.call(@user, :id, :first_name, :last_name, :nickname, :image, :email)
    json.call(@user.settings, :language, :phone, :phone_2, :skype, :country, :city, :status)
  end
end