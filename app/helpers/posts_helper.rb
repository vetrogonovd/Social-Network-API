module PostsHelper

  def get_posts
    params[:user_id].blank? ? get_all_posts : get_user_posts
  end

  private

  def get_all_posts
    if params[:last_created_at].blank?
      @posts = Post.accessible_by(current_ability).order(created_at: :desc).first(3)
    else
      @posts = Post.accessible_by(current_ability).where('created_at < ?', params[:last_created_at]).order(created_at: :desc).first(3)
    end
  end

  def get_user_posts
    @user = User.find_by(id: params[:user_id])
    if params[:last_created_at].blank?
      @posts = @user.posts.accessible_by(current_ability).order(created_at: :desc).first(3)
    else
      @posts = @user.posts.accessible_by(current_ability).where('created_at < ?', params[:last_created_at]).order(created_at: :desc).first(3)
    end
  end
end