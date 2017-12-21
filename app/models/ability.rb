class Ability
  include CanCan::Ability

  def initialize(user, member = nil, role = nil)
    user ||= User.new

    alias_action  :read, :get_users, to: :see
    alias_action  :change_user_role, :delete_user, to: :moderate_user

    # Posts
    can :see, Post, access: 'Public'
    can :see, Post, id: user.posts.map { |post| post.id }

    # Groups
    can :create, Group

    can :see, Group, access: 'Public'
    can :see, Group, id: user.groups.map { |group| group.id }

    can :update, Group do |group|
      current_user_role = GroupUser.find_by(group_id: group, user_id: user).role
      ['owner', 'admin'].include?(current_user_role)
    end

    can :destroy, Group do |group|
      GroupUser.find_by(group_id: group, user_id: user).role == 'owner'
    end

    can :add_user, Group, access: 'Public'
    can :add_user, Group do |group|
      user_group = GroupUser.find_by(group_id: group, user_id: user)
      ['owner', 'admin'].include?(user_group.role) if user_group
    end

    can :delete_user, Group do |group|
      current_user_role = GroupUser.find_by(group_id: group, user_id: user).role
      user == member && current_user_role != 'owner'
    end

    can :moderate_user, Group do |group|
      current_user_role = GroupUser.find_by(group_id: group, user_id: user).role
      member_role = GroupUser.find_by(group_id: group, user_id: member).role
      ['owner', 'admin'].include?(current_user_role) && ['admin', 'user'].include?(member_role) && role != 'owner'
    end
  end
end
