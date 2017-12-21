require 'rails_helper'

describe Api::V3::LikesController, type: :controller do

  before do
    authenticate_user
    @post = create(:post, user_id: @user.id)
    @comment = @post.comments.create(user_id: @user.id, content: "Content")
  end

  it "should create like post" do
    post :like, params: { post_id: @post.id }, format: :json
    expect(response).to have_http_status(:success)
    expect(@post.like_count(@post.id)).to equal(1)
  end

  it "should delete like post" do
    @like = @post.likes.create(user_id: @user.id)
    post :like, params: { post_id: @post.id }, format: :json
    expect(response).to have_http_status(:success)
    expect(@post.like_count(@post.id)).to equal(0)
  end

  it "should not create incorrect data like post" do
    post :like, params: { post_id: "abc" }, format: :json
    expect(response).to have_http_status(404)
  end

  it "should not create like comment" do
    post :like, params: { comment_id: @comment.id }, format: :json
    expect(response).to have_http_status(:success)
    expect(@comment.like_count(@comment.id)).to equal(1)
  end
  it "should not delete like comment" do
    @like = @comment.likes.create(user_id: @user.id)
    post :like, params: { comment_id: @comment.id }, format: :json
    expect(response).to have_http_status(:success)
    expect(@comment.like_count(@comment.id)).to equal(0)
  end
  it "should not create incorrect data like comment" do
    post :like, params: { comment_id: "abc" }, format: :json
    expect(response).to have_http_status(404)
  end

  describe "Should get likes names" do
    it "should get current_user like name" do
      likes_names = []
      @post.likes.create(user_id: @user.id)
      likes_names.push(@user.return_name)
      post :get_names, params: { post_id: @post.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['data']['likes_names']).to eq(likes_names)
    end

    it "should get names followers" do
      folower_users = FactoryGirl.create_list(:user, 10)
      likes_names = []
      folower_users.each do |u|
        u.follow @user.id
        @post.likes.create(user_id: u.id)
        likes_names.push(u.return_name)
      end

      post :get_names, params: { post_id: @post.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['data']['likes_names']).to eq(likes_names)
    end

    it "should get names more than 10" do
      folower_users = FactoryGirl.create_list(:user, 11)
      likes_names = []
      folower_users.each do |u|
        u.follow @user.id
        @post.likes.create(user_id: u.id)
        likes_names.push(u.return_name)
      end
      likes_names[-1] = 'and 1 more'
      post :get_names, params: { post_id: @post.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['data']['likes_names']).to eq(likes_names)
    end

    it "should not get names if no likes" do
      post :get_names, params: { post_id: @post.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['data']['likes_names']).to eq(nil)
    end
  end
end