class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  include RegistrationsDoc

  protected

  def sign_up_params
    params.permit(*params_for_resource(:sign_up) + [:password_confirmation, :first_name, :last_name])
  end

  def account_update_params
    params.permit(*params_for_resource(:account_update).delete(:email))
  end
end