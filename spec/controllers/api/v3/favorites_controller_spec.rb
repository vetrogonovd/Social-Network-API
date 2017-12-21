require 'rails_helper'

describe Api::V3::FavoritesController, type: :controller do

  before do
    authenticate_user
  end

  describe "GET 'index'" do
    it "should returns all user favorites" do
      @user.favorites.create(quote: 'AUDCAD')
      @user.favorites.create(quote: 'EURUSD')
      get :index, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['favorites'].length).to eq(2)
      expect(parsed_response['favorites']).to eq(["AUDCAD", "EURUSD"])
    end
  end

  describe "PUT 'create'" do
    context "correct params format" do
      it "should create favorite" do
        expect { put :update, params: { quote: 'AUDCAD' } }.to change { @user.favorites.count }.by(1)
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete favorite if favorite already exists" do
        @user.favorites.create(quote: 'AUDCAD')
        expect { put :update, params: { quote: 'AUDCAD' } }.to change { @user.favorites.count }.by(-1)
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end
    end

    context "incorrect params format" do
      it "should not create favorite with very long name" do
        put :update, params: { quote: rand(36**26).to_s(36) }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Quote is too long (maximum is 25 characters)")
      end

      it "should not create favorite with empty name" do
        put :update, params: { quote: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Quote can't be blank")
      end
    end
  end
end