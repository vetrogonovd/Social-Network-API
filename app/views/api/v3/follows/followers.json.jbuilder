json.data do
  json.followers do
    json.array!(@user.followers) do |follower|
      json.call(follower, :id, :first_name, :last_name, :nickname, :image)
    end
  end
end