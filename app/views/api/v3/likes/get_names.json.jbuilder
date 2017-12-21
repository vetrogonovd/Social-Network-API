json.data do
  json.liked_id @likable.id
  json.count_likes @likable.like_count(@likable.id)
  json.likes_names @names
end