require 'rails_helper'

RSpec.describe Group, type: :model do
  before do
    @user = build(:user)
  end

  it 'is valid with valid attributes' do
    expect(Group.new(name: 'New Group', description: 'Group description')).to be_valid
  end

  it 'is not valid without a name' do
    group = Group.new(name: nil, description: 'Group description')
    expect(group).to_not be_valid
  end

  it 'is not valid with with very long description' do
    group = Group.new(name:'New Group', description: rand(36**301).to_s(36))
    expect(group).to_not be_valid
  end

  it 'is not valid with with invalid access' do
    group = Group.new(name:'New Group', access: 'Access')
    expect(group).to_not be_valid
  end
end