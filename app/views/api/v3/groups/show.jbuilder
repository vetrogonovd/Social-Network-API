json.data do
  json.group do
    json.call(@group, :id, :name, :description, :access, :image)
  end
end