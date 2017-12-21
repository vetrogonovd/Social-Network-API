class Api::V3::FollowsController < BaseController

  include FollowsDoc

  before_action :find_user

  def create
    if current_user.following.exclude? @user
      current_user.follow @user.id
      head(:ok)
    else
      render json: { errors: "You've already follow this user" },
             status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.following.include? @user
      current_user.unfollow @user.id
      head(:ok)
    else
      render json: { errors: "You haven't follow this user yet" },
             status: :unprocessable_entity
    end
  end

  def get_followings
    render :followings, status: :ok
  end

  def get_followers
    render :followers, status: :ok
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end

end