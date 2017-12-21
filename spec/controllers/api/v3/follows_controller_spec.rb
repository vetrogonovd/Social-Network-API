require 'rails_helper'

describe Api::V3::FollowsController, type: :controller do

  before do
    authenticate_user
    @follow_user = create(:user)
  end

  describe "GET 'followres/followings'" do
    it "should returns a successful response on following" do
      get :get_followings, params: { user_id: @user }, format: :json
      expect(response).to have_http_status(:success)
    end

    it "should returns all followings" do
      users = FactoryGirl.create_list(:user, 5)
      users.each do |u|
        @user.follow u.id
      end
      get :get_followings, params: { user_id: @user }, format: :json
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['followings'].length).to eq(5)
    end

    it "should returns a successful response on followers" do
      get :get_followers, params: { user_id: @user }, format: :json
      expect(response).to have_http_status(:success)
    end

    it "should returns all followings" do
      users = FactoryGirl.create_list(:user, 5)
      users.each do |u|
        u.follow @user.id
      end
      get :get_followers, params: { user_id: @user }, format: :json
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['followers'].length).to eq(5)
    end
  end

  describe "POST 'create'" do
    context "correct params format" do
      it "should follow user and returns a successful response" do
        post :create, params: { user_id: @follow_user }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should change followings count by 1" do
        expect { post :create, params: { user_id: @follow_user } }.to change { @user.following.count }.by(1)
      end
    end

    context "incorrect params format" do
      it "should returns an error if following already exists" do
        @user.follow @follow_user.id
        post :create, params: { user_id: @follow_user }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("You've already follow this user")
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @user.follow @follow_user.id
    end

    context "correct params format" do
      it "should unfollow user and returns a successful response" do
        delete :destroy, params: { user_id: @follow_user }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should change task count by -1" do
        expect { delete :destroy,  params: { user_id: @follow_user } }.to change { @user.following.count }.by(-1)
      end
    end

    context "incorrect params format" do
      it "should returns an error if you haven't follow user" do
        @user.unfollow @follow_user.id
        delete :destroy, params: { user_id: @follow_user }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("You haven't follow this user yet")
      end
    end
  end
end