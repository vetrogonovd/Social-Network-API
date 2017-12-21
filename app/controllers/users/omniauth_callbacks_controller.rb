class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

  protected

  def assign_provider_attrs(user, auth_hash)
    user.assign_attributes(
      first_name: auth_hash['info']['first_name'],
      last_name:  auth_hash['info']['last_name'],
      email:      auth_hash['info']['email'],
      image:      auth_hash['info']['image']
    )
  end
end