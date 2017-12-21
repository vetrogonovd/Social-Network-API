module CommentsDoc
  extend Apipie::DSL::Concern

  # Post comments

  api :GET, 'api/v3/posts/:post_id/comments', 'Get post comments'
  description 'Without params this action will return 3 last comments. With last_created_at param it will return 5 comments after last one'
  error code: 401, desc: 'Unauthorized'
  param :last_created_at, Date, desc: 'Last comment created_at attribute'
  example '
  {
    "data": {
        "comment": [
            {
                "id": "64f9fc9f-b29e-4885-a5dd-74d10ea7f513",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "commentable_type": "Post"
                "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
                "content": "Some comment content",
                "file": "https://link-to-file.com",
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Vasya",
                "author_last_name": "Pupkin"
                "file": "https://link-to-file.com",
                "likes_count": 12,
                "liked": false,
                "meta": {
                    "meta_title": "Лента.Ру",
                    "meta_description": "Новости, статьи, фотографии, видео",
                    "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                    "meta_link": "https://lenta.ru/"
                }
            },
            {
                "id": "a63a05ed-2e61-4947-b07b-5cf49ad65b94",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "commentable_type": "Post"
                "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
                "content": "Cool comment",
                "file": null,
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Vasya",
                "author_last_name": "Pupkin"
                "file": null,
                "likes_count": 2,
                "liked": true
            }
        ]
    }
  }'
  def show_post_comments; end

  api :POST, 'api/v3/posts/:post_id/comments', 'Create post comment'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :comment, Hash, required: true do
    param :content, String, desc: 'Comment content'
    param :file, ['Base64'], desc: 'Comment file'
    param :meta, Hash do
      param :meta_title, String, desc: 'Comment content url meta title'
      param :meta_description, String, desc: 'Comment content url meta description'
      param :meta_image, String, desc: 'Comment content url meta image'
      param :meta_link, String, desc: 'Comment content url meta link'
    end
  end
  example '
  {
    "data": {
        "comment": {
            "id": "ca47e632-1c69-4e65-9ee9-4eed8d431dc4",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "commentable_type": "Post"
            "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
            "content": "Some comment content",
            "file": "https://link-to-file.com",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-25T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin"
            "file": "https://link-to-file.com",
            "likes_count": 1,
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
  def create_post_comment; end

  api :PUT, 'api/v3/posts/:post_id/comments/:id', 'Update post comment'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :comment, Hash, required: true do
    param :content, String, desc: 'Comment content'
    param :file, ['Base64'], desc: 'Comment file'
    param :meta, Hash do
      param :meta_title, String, desc: 'Comment content url meta title'
      param :meta_description, String, desc: 'Comment content url meta description'
      param :meta_image, String, desc: 'Comment content url meta image'
      param :meta_link, String, desc: 'Comment content url meta link'
    end
  end
  example '
  {
    "data": {
        "comment": {
            "id": "ca47e632-1c69-4e65-9ee9-4eed8d431dc4",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "commentable_type": "Post"
            "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
            "content": "Some comment content",
            "file": "https://link-to-file.com",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-26T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "likes_count": 1,
            "liked": true
            "meta": {
              "meta_title": "Лента.Ру",
              "meta_description": "Новости, статьи, фотографии, видео",
              "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
              "meta_link": "https://lenta.ru/"
            }
        }
    }
  }'
  def update_post_comment; end

  api :DELETE, 'api/v3/posts/:post_id/comments/:id', 'Delete post comment'
  error code: 401, desc: 'Unauthorized'
  example ':no_content, status: 200'
  def delete_post_comment; end


  # Comment replies

  api :GET, 'api/v3/comments/:comment_id/comments', 'Get comment replies'
  description 'Without params this action will return 3 last comments. With last_created_at param it will return 5 comments after last one'
  error code: 401, desc: 'Unauthorized'
  param :last_created_at, Date, desc: 'Last comment created_at attribute'
  example '
  {
    "data": {
        "comment": [
            {
                "id": "6ac1aed4-a67b-4c59-917a-9992110e4c56",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "commentable_type": "Comment"
                "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
                "content": "Some comment content",
                "file": "https://link-to-file.com",
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Vasya",
                "author_last_name": "Pupkin",
                "likes_count": 1,
                "liked": true,
                "meta": {
                  "meta_title": "Лента.Ру",
                  "meta_description": "Новости, статьи, фотографии, видео",
                  "meta_image": "https://icdn.lenta.ru/assets/webpack/images/lenta_og.png",
                  "meta_link": "https://lenta.ru/"
                 }
            },
            {
                "id": "29600c38-f409-4941-b061-66fc8f01b4f0",
                "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
                "commentable_type": "Comment"
                "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
                "content": "Cool comment",
                "file": null,
                "created_at": "2017-07-25T00:00:00.000Z",
                "updated_at": "2017-07-25T00:00:00.000Z",
                "author_first_name": "Vasya",
                "author_last_name": "Pupkin",
                "likes_count": 1,
                "liked": true
            }
        ]
    }
  }'
  def show_comments_reply; end

  api :POST, 'api/v3/comments/:comment_id/comments', 'Create comment reply'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :comment, Hash, required: true do
    param :content, String, desc: 'Comment content'
    param :file, ['Base64'], desc: 'Comment file'
    param :meta, Hash do
      param :meta_title, String, desc: 'Comment content url meta title'
      param :meta_description, String, desc: 'Comment content url meta description'
      param :meta_image, String, desc: 'Comment content url meta image'
      param :meta_link, String, desc: 'Comment content url meta link'
    end
  end
  example '
  {
    "data": {
        "comment": {
            "id": "29600c38-f409-4941-b061-66fc8f01b4f0",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "commentable_type": "Comment"
            "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
            "content": "Some comment content",
            "file": "https://link-to-file.com",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-25T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "likes_count": 0,
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
  def create_comment_reply; end

  api :PUT, 'api/v3/comments/:comment_id/comments/:id', 'Update comment reply'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :comment, Hash, required: true do
    param :content, String, desc: 'Comment content'
    param :file, ['Base64'], desc: 'Comment file'
    param :meta, Hash do
      param :meta_title, String, desc: 'Comment content url meta title'
      param :meta_description, String, desc: 'Comment content url meta description'
      param :meta_image, String, desc: 'Comment content url meta image'
      param :meta_link, String, desc: 'Comment content url meta link'
    end
  end
  example '
  {
    "data": {
        "comment": {
            "id": "29600c38-f409-4941-b061-66fc8f01b4f0",
            "user_id": "18d929c2-766e-4886-ae2c-f67b721466a2",
            "commentable_type": "Comment"
            "commentable_id": "5ceb2137-638f-4336-9a7d-5f69215b531d"
            "content": "Some comment content",
            "file": "https://link-to-file.com",
            "created_at": "2017-07-25T00:00:00.000Z",
            "updated_at": "2017-07-26T00:00:00.000Z",
            "author_first_name": "Vasya",
            "author_last_name": "Pupkin",
            "likes_count": 0,
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
  def update_comment_reply; end

  api :DELETE, 'api/v3/comments/:comment_id/comments/:id', 'Delete comment reply'
  error code: 401, desc: 'Unauthorized'
  example ':no_content, status: 200'
  def delete_comment_reply; end
end