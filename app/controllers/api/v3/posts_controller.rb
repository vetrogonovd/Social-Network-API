class Api::V3::PostsController < BaseController

  include MetaTagsHelper
  include PostsHelper
  include PostsDoc

  before_action :find_post, only: [:update, :destroy]

  def index
    begin
      get_posts
      render :index, status: :ok
    rescue Exception
      render json: { errors: "Incorrect params" }, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    authorize! :show, @post
    render :show, status: :ok if @post
  end

  def create
    @post = current_user.posts.create(create_post_params)
    if @post.persisted?
      @post.upload_image params[:post][:file] if params[:post][:file].present?
      save_meta_tags @post if params[:post][:meta].present?
      render :create, status: :created
    else
      render json: @post.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    post_updated = @post.update(update_post_params)
    if post_updated
      @post.update_image params[:post][:file] if params[:post][:file]
      if params[:post][:meta]
        update_meta_tags @post
        @post.reload
      end
      render :update, status: :ok
    else
      render json: @post.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      @post.delete_image if @post.file
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def find_post
    @post = current_user.posts.find(params[:id])
  end

  def create_post_params
    if params[:post][:market] == 'Simple'
      params.require(:post).permit(:market, :access, :content)
    else
      params.require(:post).permit(:quote, :market, :recommend, :price,
                                   :access, :content, :forecast)
    end
  end

  def update_post_params
    params.require(:post).permit(:access, :content)
  end
end