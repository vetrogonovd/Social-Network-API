class Api::V3::UserSettingsController < BaseController

  include UserSettingsDoc

  def get_user_info
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      render :get_user_info
    else
      render json: { errors: 'User not found' }, status: :not_found
    end
  end

  def update_personal_info
    user_updated = user_params.present? ? current_user.update(user_params) : true
    settings_updated = settings_params.present? ? current_user.settings.update_attributes(settings_params) : true
    if user_updated && settings_updated
      render :update_personal_settings, status: :ok
    else
      render json: current_user.errors.full_messages + current_user.settings.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update_privacy
    begin
      settings_updated = current_user.settings.update_attributes(privacy_params)
      if settings_updated
        head(:ok)
      else
        render json: current_user.settings.errors.full_messages, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: { errors: e }, status: :unprocessable_entity
    end
  end

  def update_language
    settings_updated = current_user.settings.update_attributes(language: params[:language])
    if settings_updated
      head(:ok)
    else
      render json: current_user.settings.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nickname)
  end

  def settings_params
    params.require(:user).permit(:phone, :phone_2, :skype, :country, :city, :status)
  end

  def privacy_params
    params.require(:user).permit(:show_phones, :show_skype, :show_country, :show_city, :show_status)
  end
end