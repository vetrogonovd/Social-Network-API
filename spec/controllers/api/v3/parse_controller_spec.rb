require 'rails_helper'

describe Api::V3::ParseController, type: :controller do

  before do
    authenticate_user
    @url = 'https://lenta.ru/'
  end

  describe "Should parse link" do
    it "should parse link with status 200" do
      post :parse_url, params: { url: @url }, format: :json
      expect(response).to have_http_status(:success)
    end

    it "should parse link with meta tags" do
      post :parse_url, params: { url: @url }, format: :json
      result = JSON.parse(response.body)['response']
      expect(result['meta_title']).to eq('Лента.Ру')
      expect(result['meta_description']).to eq('Новости, статьи, фотографии, видео. Семь дней в неделю, 24 часа в сутки.')
      expect(result['meta_image']).to eq('https://icdn.lenta.ru/assets/webpack/images/04ceff52e5b673154a365683e768578e.lenta_og.png')
    end
  end

  describe "Should not parse link" do
    it "should not parse link with bad URL and status 422" do
      post :parse_url, params: { url: 'bad-url.com' }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end