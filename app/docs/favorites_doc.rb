module FavoritesDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v3/favorites', 'Get all user favorites'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "favorites": [
            "AUDCAD",
            "EURUSD",
            "EURJPY"
        ]
    }
  }'
  def index; end

  api :PUT, 'api/v3/favorites', 'Add quote to favorites or delete quote from favorites'
  description 'This action will add quote to favorites or delete quote from favorites, depends on has been this quote already added to favorites or not'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :quote, String, desc: 'Quote name', required: true
  example ':no_content, status: 200'
  def update; end
end