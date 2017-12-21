module GroupsDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v3/groups', 'Get all allowed groups'
  error code: 401, desc: 'Unauthorized'
  example '
  {
    "data": {
        "user_groups": [
            {
                "id": "36640b2a-8462-4d95-8c19-575909df3f85",
                "name": "Top secret group",
                "description": "Some description",
                "access": "Private",
                "image": "https://link-to-file.com",
            },
            {
                "id": "3aae821e-1428-446e-80a3-ecd1181509a2",
                "name": "Group name",
                "description": "Group description",
                "access": "Public",
                "image": ""
            }
        ],
        "groups": [
            {
                "id": "b831b3cb-0ba8-4fda-a063-4ef0d90bde31",
                "name": "Some cool name",
                "description": "Group about something",
                "access": "Public",
                "image": "https://link-to-file.com"
            },
            {
                "id": "4hhe823f-1788-412g-80a3-ecd1181851k1",
                "name": "One more group",
                "description": "One more description",
                "access": "Public",
                "image": ""
            }
        ]
    }
  }'
  def index; end

  api :GET, 'api/v3/groups/:id', 'Get one group'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example '
  {
    "data": {
        "group": {
            "id": "3aae821e-1428-446e-80a3-ecd1181509a2",
            "name": "Group name",
            "description": "Some description",
            "access": "Public",
            "image": "https://link-to-file.com"
        }
    }
  }'
  def show; end

  api :POST, 'api/v3/groups', 'Create group'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 422, desc: 'Unprocessable entity'
  param :group, Hash, required: true do
    param :name, String, desc: 'Group name', required: true
    param :description, String, desc: 'Group description'
    param :access, ['"Private"'], desc: 'Group access. Default is "Public"'
    param :users, Array, desc: 'Array of users id. This users will be added to group automatically'
  end
  example '
  {
    "data": {
        "group": {
            "id": "3aae821e-1428-446e-80a3-ecd1181509a2",
            "name": "Group name",
            "description": "Some description",
            "image": "",
            "access": "Public"
        }
    }
  }'
  def create; end

  api :PUT, 'api/v3/groups/:id', 'Update group'
  error code: 400, desc: 'Bad request'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  error code: 422, desc: 'Unprocessable entity'
  param :group, Hash, required: true do
    param :name, String, desc: 'New group name'
    param :description, String, desc: 'New group description'
    param :image, ['Base64'], desc: 'Group image'
  end
  example '
  {
    "data": {
        "group": {
            "id": "3aae821e-1428-446e-80a3-ecd1181509a2",
            "name": "New name",
            "description": "New description",
            "access": "Public",
            "image": "https://link-to-file.com"
        }
    }
  }'
  def update; end

  api :DELETE, 'api/v3/groups/:id', 'Delete group'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example ':no_content, status: 200'
  def destroy; end

  api :GET, 'api/v3/groups/:group_id/get_users', 'Get all group users'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example '
  {
    "data": {
        "users_count": 2,
        "users": [
            {
                "id": "9b300932-e100-42c1-93ab-5fe54e252d3b",
                "email": "petya@gmail.com",
                "first_name": "Petya",
                "last_name": "Pupkin",
                "nickname": null,
                "image": "https://link-to-file.com",
                "role": "owner"
            },
            {
                "id": "87cc1e11-3e66-4c45-9d97-e59d92866e91",
                "email": "vasya@gmail.com",
                "first_name": "Vasya",
                "last_name": "Supkin",
                "nickname": "Boss",
                "image": null,
                "role": "user"
            }
        ]
    }
  }'
  def get_users; end

  api :POST, 'api/v3/groups/:group_id/add_user/:user_id', 'Add user to group'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example ':no_content, status: 200'
  def add_user; end

  api :DELETE, 'api/v3/groups/:group_id/delete_user/:user_id', 'Delete user from group'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example ':no_content, status: 200'
  def delete_user; end

  api :PUT, 'api/v3/groups/:group_id/change_user_role/:user_id', 'Change user role'
  error code: 401, desc: 'Unauthorized'
  error code: 403, desc: 'Forbidden'
  example ':no_content, status: 200'
  param :role, ['"admin", "user"'], desc: 'User role', required: true
  def change_user_role; end
end