module PostsDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v3/posts', 'Get all posts'
  description 'Without params this action will return 3 last posts. With last_created_at param it will return 3 posts after last one'
  error code: 401, desc: 'Unauthorized'
  param :last_created_at, Date, desc: 'Last post created_at attribute'
  example '
  {
    "data": {
        "post": [
            {
                "id": "80451f96-afd5-46cb-a0b7-04496ce85af6",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "quote": "EURUSD",
                "market": "Currency",
                "recommend": "Sell",
                "price": 1.0987,
                "access": "Public",
                "file": "https://link-to-file.com",
                "content": "Some cool news",
                "forecast": "2017-07-29T00:00:00.000Z",
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Vasya",
                "author_last_name": "Pupkin",
                "author_avatar": "https://link-to-file.com",
                "likes_count": 77,
                "comments_count": 205,
                "liked": true,
                "meta": {
                    "meta_title": "Лента.Ру",
                    "meta_description": "Новости, статьи, фотографии, видео",
                    "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                    "meta_link": "https://lenta.ru/"
                }
            },
            {
                "id": "b0445cfc-e3aa-4ef0-9c84-f3eedb6c07df",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "quote": "AUDCAD",
                "market": "Currency",
                "recommend": "Buy",
                "price": 22.678,
                "access": "Public",
                "file": null,
                "content": "Some post content",
                "forecast": "2017-07-29T00:00:00.000Z",
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Petya",
                "author_last_name": "Supkin",
                "author_avatar": null,
                "likes_count": 150,
                "comments_count": 400,
                "liked": false
            },
        ]
    }
  }'
  def index; end

  api :GET, 'api/v3/posts/:id', 'Get one post'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "post": {
            "id": "b0445cfc-e3aa-4ef0-9c84-f3eedb6c07df",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "quote": "AUDCAD",
            "market": "Currency",
            "recommend": "Sell",
            "price": 1.0987,
            "access": "Public",
            "file": "https://link-to-file.com",
            "content": "Some cool news",
            "forecast": "2017-07-29T00:00:00.000Z",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-25T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "author_avatar": "https://link-to-file.com",
            "likes_count": 33,
            "comments_count": 205,
            "liked": true,
            "meta": {
                "meta_title": "Лента.Ру",
                "meta_description": "Новости, статьи, фотографии, видео",
                "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                "meta_link": "https://lenta.ru/"
            }
        }
    }
  }'
  def show; end

  api :POST, 'api/v3/posts', 'Create post'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :post, Hash, required: true do
    param :quote, String, desc: 'Post quote'
    param :market, ['"Currency"','"Commodity"','"Index"','"Stock"','"Crypto"','"Simple"'], desc: 'Post market'
    param :recommend, ['"Sell"','"Buy"'], desc: 'Post recommend'
    param :price, Float, desc: 'Post price'
    param :access, ['"Public"','"Private"'], desc: 'Post access'
    param :file, ['Base64'], desc: 'Post file (required if content is empty)'
    param :content, String, desc: 'Post content (required if file is empty)'
    param :forecast, [String, Date], desc: 'Post forecast time'
    param :meta, Hash do
      param :meta_title, String, desc: 'Post content url meta title'
      param :meta_description, String, desc: 'Post content url meta description'
      param :meta_image, String, desc: 'Post content url meta image'
      param :meta_link, String, desc: 'Post content url meta link'
    end
  end
  example '
  {
    "data": {
        "post": {
            "id": "1cb93e7f-12a3-4fd5-91ed-1d03c03fbf69",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "quote": "AUDHUF",
            "market": "Currency",
            "recommend": "Sell",
            "price": 1.0987,
            "access": "Public",
            "file": "https://link-to-file.com",
            "content": "Some cool news",
            "forecast": "2017-07-29T00:00:00.000Z",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-25T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "author_avatar": "https://link-to-file.com",
            "likes_count": 0,
            "comments_count": 0,
            "liked": false,
            "meta": {
                "meta_title": "Лента.Ру",
                "meta_description": "Новости, статьи, фотографии, видео",
                "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                "meta_link": "https://lenta.ru/"
            }
        }
    }
  }'
  def create; end

  api :PUT, 'api/v3/posts/:id', 'Update post'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :post, Hash, required: true do
    param :access, ['"Public"','"Private"'], desc: 'Post access'
    param :content, String, desc: 'Post content (required if file is empty)'
    param :file, ['Base64'], desc: 'Post file (required if content is empty)'
    param :meta, Hash do
      param :meta_title, String, desc: 'Post content url meta title'
      param :meta_description, String, desc: 'Post content url meta description'
      param :meta_image, String, desc: 'Post content url meta image'
      param :meta_link, String, desc: 'Post content url meta link'
    end
  end
  example '
  {
    "data": {
        "post": {
            "id": "1cb93e7f-12a3-4fd5-91ed-1d03c03fbf69",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "quote": "AUDHUF",
            "market": "Currency",
            "recommend": "Sell",
            "price": 1.0987,
            "access": "Public",
            "file": "https://link-to-file.com",
            "content": "Some cool news",
            "forecast": "2017-07-29T00:00:00.000Z",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-26T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "author_avatar": "https://link-to-file.com",
            "likes_count": 0,
            "comments_count": 0,
            "liked": false,
            "meta": {
                "meta_title": "Лента.Ру",
                "meta_description": "Новости, статьи, фотографии, видео",
                "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                "meta_link": "https://lenta.ru/"
            }
        }
    }
  }'
  def update; end

  api :DELETE, 'api/v3/posts/:id', 'Delete post'
  error code: 401, desc: 'Unauthorized'
  example ':no_content, status: 200'
  def destroy; end
end