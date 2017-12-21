class Api::V3::FavoritesController < BaseController

  include FavoritesDoc

  def index
    @favorites = current_user.favorites.all.collect(&:quote)
    render :index, status: :ok
  end

  def update
    favorite = Favorite.find_by user_id: current_user, quote: params[:quote]
    if favorite.present?
      favorite.destroy
      head(:ok)
    else
      favorite = Favorite.create user_id: current_user.id, quote: params[:quote]
      if favorite.persisted?
        head(:ok)
      else
        render json: favorite.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

end