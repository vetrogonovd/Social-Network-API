module ParseDoc
  extend Apipie::DSL::Concern

  api :POST, 'api/v3/parse_url', 'Parse meta tags from URL'
  error code: 422, desc: 'Unprocessable entity'
  param :url, String, required: true
  example '
  {
    "response": {
        "meta_title": "Lenta.ru",
        "meta_description": "Новости, статьи, фотографии, видео. Семь дней в неделю, 24 часа в сутки.",
        "meta_image": "https://icdn.lenta.ru/assets/webpack/images/04ceff52e5b673154a365683e768578e.lenta_og.png"
    }
  }'
  def parse_url; end

end