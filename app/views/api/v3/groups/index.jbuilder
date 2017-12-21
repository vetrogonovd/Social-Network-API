json.data do
  json.user_groups do
    json.array!(current_user.groups, :id, :name, :description, :access, :image)
  end

  json.groups do
    json.array!(@groups, :id, :name, :description, :access, :image)
  end
end