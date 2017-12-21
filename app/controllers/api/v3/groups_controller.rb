class Api::V3::GroupsController < BaseController

  include GroupsDoc

  load_and_authorize_resource except:[:add_user, :delete_user, :change_user_role]
  before_action :find_member, only: [:add_user, :delete_user, :change_user_role]
  before_action :find_group, except: [:index, :create, :get_users]

  def index
    all_groups = Group.accessible_by(current_ability)
    @groups = all_groups.where.not(id: current_user.groups.map(&:id))
    render :index, status: :ok
  end

  def create
    @group = current_user.groups.create(create_params)
    if @group.persisted?
      @group.set_owner
      @group.add_users @users if create_group_with_users
      render :create, status: :created
    else
      render json: @group.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render :show, status: :ok
  end

  def update
    group_updated = @group.update(update_params)
    if group_updated
      @group.update_image params[:group][:image] if params[:group][:image]
      render :update, status: :ok
    else
      render json: @group.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @group.destroy
      @group.delete_image if @group.image
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  def get_users
    @group = Group.accessible_by(current_ability).where(id: params[:group_id]).first
    authorize! :get_users, @group
    render :get_users, status: :ok
  end

  def add_user
    authorize! :add_user, @group
    begin
    member = GroupUser.create(group_id: @group.id, user_id: @member.id)
    if member.persisted?
      head(:ok)
    else
      render json: member.errors.full_messages, status: :unprocessable_entity
    end
    rescue Exception
      render json: { errors: "User already in this group" }, status: :unprocessable_entity
    end
  end

  def delete_user
    authorize! :delete_user, @group
    if GroupUser.find_by(group_id: @group.id, user_id: @member.id).destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  def change_user_role
    authorize! :change_user_role, @group
     if @group.change_user_role(@member, params[:role])
       head(:ok)
     else
       render json: { errors: "Incorrect role" }, status: :unprocessable_entity
     end
  end

  private

  def create_params
    params.require(:group).permit(:name, :description, :access)
  end

  def update_params
    params.require(:group).permit(:name, :description)
  end

  def find_group
    if params[:group_id]
      @group = Group.find(params[:group_id])
    else
      @group = Group.find(params[:id])
    end
  end

  def find_member
    @member = User.find(params[:user_id])
  end

  def create_group_with_users
    @users = params[:group][:users] if params[:group][:users] && params[:group][:users].length > 0
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, @member, params[:role])
  end
end