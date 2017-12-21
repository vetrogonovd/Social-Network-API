class Api::V3::CommentsController < BaseController

  include MetaTagsHelper
  include CommentsDoc

  before_action :find_commentable, only: [:index, :create]
  before_action :find_comment, only: [:update, :destroy]

  def index
    begin
      if params[:last_created_at].blank?
        @comments = @commentable.comments.first(3)
      else
        @comments = @commentable.comments.where('created_at < ?', params[:last_created_at]).first(5)
      end
      render :index, status: :ok
    rescue Exception
      render json: { errors: "Incorrect last created at date format" }, status: :unprocessable_entity
    end
  end

  def create
    @comment = @commentable.comments.create(comment_params)
    if @comment.persisted?
      @comment.upload_image params[:comment][:file] if params[:comment][:file].present?
      save_meta_tags @comment if params[:comment][:meta].present?
      render :create, status: :created
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    comment_updated = @comment.update(comment_params)
    if comment_updated
      @comment.update_image params[:comment][:file] if params[:comment][:file]
      if params[:comment][:meta]
        update_meta_tags @comment
        @comment.reload
      end
      render :update, status: :ok
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      @comment.delete_image if @comment.file
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def find_commentable
    @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
    @commentable = Post.find(params[:post_id]) if params[:post_id]
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
