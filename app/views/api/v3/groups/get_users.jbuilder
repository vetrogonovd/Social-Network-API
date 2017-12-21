json.data do
  json.users_count @group.users.count
  json.users do
    json.array!(@group.users) do |user|
      json.(user, :id, :email, :first_name, :last_name, :nickname, :image)
      json.role GroupUser.find_by(group_id: @group, user_id: user).role
    end
  end
end