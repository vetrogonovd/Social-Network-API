json.data do
  json.posts do
    json.array!(@posts) do |post|
      json.call(post, :id, :user_id, :quote, :market, :recommend,
                :price, :access, :file, :content, :forecast, :created_at, :updated_at)
      json.author_first_name post.user.first_name
      json.author_last_name post.user.last_name
      json.author_avatar post.user.image
      json.likes_count post.like_count(post.id)
      json.comments_count post.comments.count
      json.liked post.liked?(current_user.id, post.id)
      json.meta do
        json.call(post.meta_tags, :meta_title, :meta_description, :meta_image, :meta_link) if post.meta_tags
      end
    end
  end
end