require 'rails_helper'

describe Api::V3::GroupsController, type: :controller do

  before do
    authenticate_user
    @user_public_groups = FactoryGirl.create_list(:group, 3)
    @user_private_groups = FactoryGirl.create_list(:group, 2, access: 'Private')
    @public_groups = FactoryGirl.create_list(:group, 10)
    @private_groups = FactoryGirl.create_list(:group, 5, access: 'Private')
    @member = FactoryGirl.create(:user)
    @user.groups << @user_public_groups <<  @user_private_groups
    @member.groups << @public_groups << @private_groups
  end

  describe "GET 'index'/'show'" do
    it "should returns all user groups and all public groups" do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['user_groups'].length).to eq(5)
      expect(parsed_response['groups'].length).to eq(10)
    end

    it "should returns user public group" do
      get :show, params: { id: @user_public_groups.first }, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['group']).not_to be_empty
    end

    it "should returns user private group" do
      get :show, params: { id: @user_private_groups.first }, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['group']).not_to be_empty
    end

    it "should returns any public group" do
      get :show, params: { id: @public_groups.first }, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)['data']
      expect(parsed_response['group']).not_to be_empty
    end

    it "should not return any private public group" do
      get :show, params: { id: @private_groups.first }, format: :json
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end
  end

  describe "POST 'create'" do
    context "correct params format" do
      it "should create public group and returns a successful response" do
        post :create, params: { group: { name: 'Group name', description: 'Group description' } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']).not_to be_empty
        expect(parsed_response['group']['access']).to eq("Public")
      end

      it "should create private group and returns a successful response" do
        post :create, params: { group: { name: 'Group name', description: 'Group description', access: 'Private' } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']).not_to be_empty
        expect(parsed_response['group']['access']).to eq("Private")
      end

      it "should change followings count by 1" do
        expect { post :create, params: { group: { name: 'Group name', description: 'Group description' } } }.to change { @user.groups.count }.by(1)
      end
    end

    context "incorrect params format" do
      it "should returns an error if group name is empty" do
        post :create, params: { group: { name: '', description: 'Group description' } }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Name is invalid")
        expect(parsed_response[1]).to eq("Name can't be blank")
      end

      it "should returns an error if group description is blank" do
        post :create, params: { group: { name: 'Group name', description: '   ' } }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Description can't be blank")
      end

      it "should returns an error if group access is invald" do
        post :create, params: { group: { name: 'Group name', description: 'Group description', access: 'Access' } }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Access is invalid")
      end
    end
  end

  describe "PUT 'update'" do
    context "correct params format" do
      it "should update group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'owner')
        put :update, params: { id: @user.groups.first, group: { name: 'New name', description: 'New description' } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']['name']).to eq("New name")
        expect(parsed_response['group']['description']).to eq("New description")
      end

      it "should update group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'admin')
        put :update, params: { id: @user.groups.first, group: { name: 'Name', description: 'Description' } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']['name']).to eq("Name")
        expect(parsed_response['group']['description']).to eq("Description")
      end

      it "should update group image and returns a successful response" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'admin')
        put :update, params: { id: @user.groups.first, group: { image: "data:image/gif;base64,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" } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']['image']).not_to be_empty
      end
    end

    context "incorrect params format" do
      it "should not update group if user" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'user')
        put :update, params: { id: @user.groups.first, group: { name: 'New name', description: 'New description' } }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not update private group access" do
        GroupUser.find_by(group_id: @user_private_groups.first, user_id: @user).update(role: 'owner')
        put :update, params: { id: @user_private_groups.first, group: { access: 'Public' } }
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']['access']).to eq("Private")
      end

      it "should not update public group access" do
        GroupUser.find_by(group_id: @user_public_groups.first, user_id: @user).update(role: 'owner')
        put :update, params: { id: @user_public_groups.first, group: { access: 'Private' } }
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['group']['access']).to eq("Public")
      end
    end
  end

  describe "DELETE 'destroy'" do
    context "correct params format" do
      it "should destroy group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'owner')
        delete :destroy, params: { id: @user.groups.first }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should change groups count by -1" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'owner')
        expect { delete :destroy, params: { id: @user.groups.first } }.to change { Group.count }.by(-1)
      end
    end

    context "incorrect params format" do
      it "should not destroy group if admin" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'admin')
        delete :destroy, params: { id: @user.groups.first }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not destroy group if user" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'user')
        delete :destroy, params: { id: @user.groups.first }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end
    end
  end

  describe "GET 'get_users'" do
    context "correct params format" do
      it "should get group users and returns a successful response if group is public" do
        get :get_users, params: { group_id: @public_groups.first }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['users']).not_to be_empty
      end

      it "should get group users and returns a successful response if you are in private group" do
        get :get_users, params: { group_id: @user_private_groups.first }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['users']).not_to be_empty
      end

      it "should get group users and returns a successful response if you are in public group" do
        get :get_users, params: { group_id: @user_public_groups.first }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['users']).not_to be_empty
      end
    end

    context "incorrect params format" do
      it "should not get group users if group is private" do
        get :get_users, params: { group_id: @private_groups.first }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end
    end
  end

  describe "POST 'add_user'" do
    context "correct params format" do
      it "should add user to public group and returns a successful response if user" do
        GroupUser.find_by(group_id: @user_public_groups.first, user_id: @user).update(role: 'user')
        post :add_user, params: { group_id: @user_public_groups.first, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should add user to public group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @user_public_groups.first, user_id: @user).update(role: 'admin')
        post :add_user, params: { group_id: @user_public_groups.first, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should add user to public group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @user_public_groups.first, user_id: @user).update(role: 'owner')
        post :add_user, params: { group_id: @user_public_groups.first, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should add user to private group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @user_private_groups.first, user_id: @user).update(role: 'admin')
        post :add_user, params: { group_id: @user_private_groups.first, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should add user to private group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @user_private_groups.first, user_id: @user).update(role: 'owner')
        post :add_user, params: { group_id: @user_private_groups.first, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should add user to any public group and returns a successful response" do
        post :add_user, params: { group_id: @public_groups.first, user_id: @user }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end
    end

    context "incorrect params format" do
      it "should not add user to any private group" do
        post :add_user, params: { group_id: @private_groups.first, user_id: @user }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not add user to group if user already added" do
        GroupUser.find_by(group_id: @user.groups.first, user_id: @user).update(role: 'admin')
        post :add_user, params: { group_id: @user.groups.first, user_id: @user }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(response.body['errors']).not_to be_empty
      end
    end
  end

  describe "DELETE 'delete_user'" do
    before do
      @public_group = FactoryGirl.create(:group)
      @private_group = FactoryGirl.create(:group, access: 'Private')
      @user.groups << @public_group << @private_group
      @member.groups << @public_group << @private_group
    end

    context "correct params format" do
      it "should delete user from public group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'user')
        delete :delete_user, params: { group_id: @public_group, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete admin from public group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'admin')
        delete :delete_user, params: { group_id: @public_group, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete yourself from public group and returns a successful response if not owner" do
        delete :delete_user, params: { group_id: @public_group, user_id: @user }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete user from private group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'user')
        delete :delete_user, params: { group_id: @private_group, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete admin from private group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'admin')
        delete :delete_user, params: { group_id: @private_group, user_id: @member }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end

      it "should delete yourself from private group and returns a successful response if not owner" do
        delete :delete_user, params: { group_id: @private_group, user_id: @user }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
      end
    end

    context "incorrect params format" do
      it "should not delete owner from public group if user" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'user')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'owner')
        delete :delete_user, params: { group_id: @public_group, user_id: @member }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not delete owner from public group if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'owner')
        delete :delete_user, params: { group_id: @public_group, user_id: @member }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not delete yourself from public group if owner" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'owner')
        delete :delete_user, params: { group_id: @public_group, user_id: @user }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not delete owner from private group if user" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'user')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'owner')
        delete :delete_user, params: { group_id: @private_group, user_id: @member }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not delete owner from private group if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'owner')
        delete :delete_user, params: { group_id: @private_group, user_id: @member }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not delete yourself from private group if owner" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'owner')
        delete :delete_user, params: { group_id: @private_group, user_id: @user }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end
    end
  end

  describe "PUT 'change_user_role'" do
    before do
      @public_group = FactoryGirl.create(:group)
      @private_group = FactoryGirl.create(:group, access: 'Private')
      @user.groups << @public_group << @private_group
      @member.groups << @public_group << @private_group
    end

    context "correct params format" do
      it "should cahnge user role to admin in public group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'user')
        put :change_user_role, params: { group_id: @public_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @public_group, user_id: @member).role).to eq('admin')
      end

      it "should cahnge admin role to user in public group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'admin')
        put :change_user_role, params: { group_id: @public_group, user_id: @member, role: 'user' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @public_group, user_id: @member).role).to eq('user')
      end

      it "should cahnge user role to admin in public group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'owner')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'user')
        put :change_user_role, params: { group_id: @public_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @public_group, user_id: @member).role).to eq('admin')
      end

      it "should cahnge admin role to user in public group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'owner')
        GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'admin')
        put :change_user_role, params: { group_id: @public_group, user_id: @member, role: 'user' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @public_group, user_id: @member).role).to eq('user')
      end

      it "should change self role in public group if admin" do
        GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
        put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'user' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @public_group, user_id: @user).role).to eq('user')
      end

      it "should cahnge user role to admin in private group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'user')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @private_group, user_id: @member).role).to eq('admin')
      end

      it "should cahnge admin role to user in private group and returns a successful response if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'admin')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'user' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @private_group, user_id: @member).role).to eq('user')
      end

      it "should cahnge user role to admin in private group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'owner')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'user')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @private_group, user_id: @member).role).to eq('admin')
      end

      it "should cahnge admin role to user in private group and returns a successful response if owner" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'owner')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'user')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @private_group, user_id: @member).role).to eq('admin')
      end

      it "should change self role in private group if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'user' }
        expect(response).to have_http_status(:success)
        expect(response.body).to be_empty
        expect( GroupUser.find_by(group_id: @private_group, user_id: @user).role).to eq('user')
      end
    end

    context "incorrect params format" do
      it "should not cahnge owner role in private group if user" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'user')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'owner')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not cahnge owner role in private group if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        GroupUser.find_by(group_id: @private_group, user_id: @member).update(role: 'owner')
        put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not change self role to admin in private group if owner" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'owner')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'admin' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not change self role to user in private group if owner" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'owner')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'user' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not change self role to owner in private group if admin" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'admin')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'owner' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not change self role to admin in private group if user" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'user')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'admin' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it "should not change self role to owner in private group if user" do
        GroupUser.find_by(group_id: @private_group, user_id: @user).update(role: 'user')
        put :change_user_role, params: { group_id: @private_group, user_id: @user, role: 'owner' }
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end
    end

    it "should not cahnge owner role in public group if user" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'user')
      GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'owner')
      put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not cahnge owner role in public group if admin" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
      GroupUser.find_by(group_id: @public_group, user_id: @member).update(role: 'owner')
      put :change_user_role, params: { group_id: @private_group, user_id: @member, role: 'admin' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not change self role to admin in public group if owner" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'owner')
      put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'admin' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not change self role to user in public group if owner" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'owner')
      put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'user' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not change self role to owner in public group if admin" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'admin')
      put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'owner' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not change self role to admin in public group if user" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'user')
      put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'admin' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end

    it "should not change self role to owner in public group if user" do
      GroupUser.find_by(group_id: @public_group, user_id: @user).update(role: 'user')
      put :change_user_role, params: { group_id: @public_group, user_id: @user, role: 'owner' }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to be_empty
    end
  end
end