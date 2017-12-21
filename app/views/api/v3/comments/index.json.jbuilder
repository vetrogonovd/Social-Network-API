json.data do
  json.comment do
    json.array!(@comments) do |comment|
      json.call(comment, :id, :user_id, :commentable_type, :commentable_id,
                :content, :file, :created_at, :updated_at)
      json.author_first_name comment.user.first_name
      json.author_last_name comment.user.last_name
      json.likes_count comment.like_count(comment.id)
      json.liked comment.liked?(current_user.id, comment.id)
      json.meta do
        json.call(comment.meta_tags,:meta_title, :meta_description, :meta_image, :meta_link) if comment.meta_tags
      end
    end
  end
end