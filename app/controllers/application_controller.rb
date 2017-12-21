class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do
    head(:forbidden)
  end

end
