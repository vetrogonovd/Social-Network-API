require 'rails_helper'

RSpec.describe Favorite, type: :model do
  before do
    @user = create(:user)
  end

  it 'is valid with valid attributes' do
    expect(Favorite.new(user_id: @user.id, quote: 'AUDCAD')).to be_valid
  end

  it 'is not valid without a name' do
    favorite = Favorite.new(user_id: @user.id)
    expect(favorite).to_not be_valid
  end

  it 'is not valid with with very long name' do
    favorite = Favorite.new(user_id: @user.id, quote: rand(36**26).to_s(36))
    expect(favorite).to_not be_valid
  end

  it 'is not valid with the same quote for one user' do
    @user.favorites.create(quote: 'AUDCAD')
    favorite = Favorite.new(user_id: @user.id, quote: 'AUDCAD')
    expect(favorite).to_not be_valid
  end
end