class Users::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  protected

  def render_validate_token_success
    render json: { success: true,
                   data: resource_data(resource_json: @resource.token_validation_response).merge(language: @resource.settings.language)
    }
  end
end