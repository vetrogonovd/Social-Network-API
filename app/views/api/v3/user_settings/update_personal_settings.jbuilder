json.data do
  json.user do
    json.call(current_user, :id, :first_name, :last_name, :nickname, :image, :email)
    json.call(current_user.settings, :phone, :phone_2, :skype, :country, :city, :status)
  end
end