module LikesDoc
  extend Apipie::DSL::Concern

  api :POST, 'api/v3/posts/:post_id/like', 'Create or delete post like'
  description 'This action will create or delete post like, depends on has been this post already liked by current user'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "liked_id": "bad82816-9caf-4c1a-919c-468a0c05d035",
        "count_likes": 55,
        "liked": true
    }
  }'
  def post_like; end

  api :POST, 'api/v3/comments/:comment_id/like', 'Create or delete comment like'
  description 'This action will create or delete comment like, depends on has been this comment already liked by current user'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "liked_id": "bad82816-9caf-4c1a-919c-468a0c05d035",
        "count_likes": 55,
        "liked": true
    }
  }'
  def comment_like; end

  api :POST, 'api/v3/posts/:post_id/get_likes_names', 'List of names, who liked current post'
  description 'This action will return list of names, who liked current post'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "liked_id": "bad82816-9caf-4c1a-919c-468a0c05d035",
        "count_likes": 11,
        "likes_names": [
            "Elroy Pfannerstill", "Elnora Heathcote", "David Dickens", "Dolores Cruickshank",
            "Gregory Sipes", "Remington Rolfson", "Ariane Littel", "Lance Pollich",
            "Amber Jaskolski", "Samanta Murray", "and 1 more"
        ]
    }
  }'
  def get_names; end
end