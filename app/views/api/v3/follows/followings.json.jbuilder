json.data do
  json.followings do
    json.array!(@user.following) do |following|
      json.call(following, :id, :first_name, :last_name, :nickname, :image)
    end
  end
end