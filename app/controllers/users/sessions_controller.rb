class Users::SessionsController < DeviseTokenAuth::SessionsController
  include SessionsDoc

  protected

  def render_create_success
    render json: { data: resource_data(resource_json: @resource.token_validation_response).merge(language: @resource.settings.language) }
  end

end