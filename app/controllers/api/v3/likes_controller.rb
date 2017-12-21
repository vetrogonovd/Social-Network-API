class Api::V3::LikesController < BaseController

  include LikesDoc
  before_action :find_likable

  def like
    head(:not_found) and return if @likable.nil?
    if @likable.liked?(current_user.id, @likable.id)
      destroy_like
    else
      create_like
    end
  end

  def get_names
    @names = @likable.return_likes_names(@likable, current_user)
    render :get_names, status: :ok
  end

  private

  def find_likable
    @likable = Post.find_by(id: params[:post_id]) if params[:post_id]
    @likable = Comment.find_by(id: params[:comment_id]) if params[:comment_id]
  end

  def create_like
    @like = @likable.likes.create(user_id: current_user.id)
    if @like.persisted?
      render :like, status: :ok
    else
      render json: @like.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy_like
    @like = Like.find_by(user_id: current_user.id, liked_id: @likable.id)
    if @like.destroy
      render :like, status: :ok
    else
      render json: @like.errors.full_messages, status: :unprocessable_entity
    end
  end
end
