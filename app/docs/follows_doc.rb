module FollowsDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v3/followings/:user_id', 'Get user followings'
  error code: 401, desc: 'Unauthorized'
  error code: 404, desc: 'Not found'
  error code: 422, desc: 'Unprocessable entity'
  example '
  {
    "data": {
        "followings": [
            {
                "id": "92672db4-4473-4444-a576-9c0a468d75eb",
                "first_name": "Vasya",
                "last_name": "Pupkin",
                "nickname": null,
                "image": "https://link-to-file.com",
            },
            {
                "id": "6f758f42-a6cf-41ee-8f3e-4aabe80fb149",
                "first_name": "Petya",
                "last_name": "Supkin",
                "nickname": "Big boss",
                "image": null
            }
        ]
    }
  }'
  def get_followings; end

  api :GET, 'api/v3/followers/:user_id', 'Get user followers'
  error code: 401, desc: 'Unauthorized'
  error code: 404, desc: 'Not found'
  error code: 422, desc: 'Unprocessable entity'
  example '
  {
    "data": {
        "followers": [
            {
                "id": "92672db4-4473-4444-a576-9c0a468d75eb",
                "first_name": "Vasya",
                "last_name": "Pupkin",
                "nickname": null,
                "image": "https://link-to-file.com",
            },
            {
                "id": "6f758f42-a6cf-41ee-8f3e-4aabe80fb149",
                "first_name": "Petya",
                "last_name": "Supkin",
                "nickname": "Big boss",
                "image": null
            }
        ]
    }
  }'
  def get_followers; end

  api :POST, 'api/v3/follow/:user_id', 'Follow user'
  error code: 401, desc: 'Unauthorized'
  error code: 404, desc: 'Not found'
  error code: 422, desc: 'Unprocessable entity'
  example ':no_content, status: 200'
  def follow; end

  api :DELETE, 'api/v3/unfollow/:user_id', 'Unfollow user'
  error code: 401, desc: 'Unauthorized'
  error code: 404, desc: 'Not found'
  error code: 422, desc: 'Unprocessable entity'
  example ':no_content, status: 200'
  def unfollow; end
end