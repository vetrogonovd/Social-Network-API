require 'rails_helper'

RSpec.describe UserSettings, type: :model do
  before do
    @user = build(:user)
  end

  it 'is valid with valid attributes' do
    expect(@user.create_settings(phone: '380671234567', phone_2: 'Group 380671234567',
                                 skype: 'user_skype', country: 'Ukraine', city: 'Dnipro')).to be_valid
  end

  it 'is valid with valid language' do
    expect(@user.create_settings(language: 'ru')).to be_valid
  end

  it 'is valid with valid privacy params' do
    expect(@user.create_settings(show_phones: 'followers', show_skype: 'followers',
                                 show_country: 'followers', show_city: 'followers', show_status: 'followers',)).to be_valid
  end

  it 'is not valid with very long phone' do
    settings = @user.create_settings(phone: rand(36**21).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with very long second phone' do
    settings = @user.create_settings(phone_2: rand(36**21).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with very long skype' do
    settings = @user.create_settings(skype: rand(36**51).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with very long country' do
    settings = @user.create_settings(country: rand(36**51).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with very long city' do
    settings = @user.create_settings(city: rand(36**51).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with very long status' do
    settings = @user.create_settings(status: rand(36**51).to_s(36))
    expect(settings).to_not be_valid
  end

  it 'is not valid with invalid language' do
    settings = @user.create_settings(language: 'de')
    expect(settings).to_not be_valid
  end
end