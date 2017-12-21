require 'rails_helper'

describe Api::V3::UserSettingsController, type: :controller do

  before do
    authenticate_user
  end

  describe "PUT 'update_personal_info'" do
    context "correct params format" do
      it "should update user first name, last name,nickname and returns a successful response" do
        put :update_personal_info, params:{ user: {first_name: 'Vasya', last_name: 'Pupkin', nickname: 'Big boss' } }, format: :json
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['user']['first_name']).to eq("Vasya")
        expect(parsed_response['user']['last_name']).to eq("Pupkin")
        expect(parsed_response['user']['nickname']).to eq("Big boss")
      end

      it "should update phone numbers and returns a successful response" do
        put :update_personal_info, params:{ user: { phone: '380671234567', phone_2: '380677654321' } }, format: :json
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['user']['phone']).to eq("380671234567")
        expect(parsed_response['user']['phone_2']).to eq("380677654321")
      end

      it "should update other settings and returns a successful response" do
        put :update_personal_info, params:{ user: { skype: 'someSkype', country: 'Afganistan', city: 'Kabul', status: 'Allah akbar' } }, format: :json
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['user']['skype']).to eq("someSkype")
        expect(parsed_response['user']['country']).to eq("Afganistan")
        expect(parsed_response['user']['city']).to eq("Kabul")
        expect(parsed_response['user']['status']).to eq("Allah akbar")
      end

      it "should update all personal settings and returns a successful response" do
        put :update_personal_info, params:{ user: { first_name: 'Petya', last_name: 'Supkin', nickname: 'Big boss',
                                                    phone: '380677777777', phone_2: '380671111111', skype: 'newSkype',
                                                    country: 'USA', city: 'Honolulu', status: 'Aloha' } }, format: :json
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)['data']
        expect(parsed_response['user']['first_name']).to eq("Petya")
        expect(parsed_response['user']['last_name']).to eq("Supkin")
        expect(parsed_response['user']['nickname']).to eq("Big boss")
        expect(parsed_response['user']['phone']).to eq("380677777777")
        expect(parsed_response['user']['phone_2']).to eq("380671111111")
        expect(parsed_response['user']['skype']).to eq("newSkype")
        expect(parsed_response['user']['country']).to eq("USA")
        expect(parsed_response['user']['city']).to eq("Honolulu")
        expect(parsed_response['user']['status']).to eq("Aloha")
      end
    end

    context "incorrect params format" do
      it "should not update user first name if blank" do
        put :update_personal_info, params:{ user: { first_name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[1]).to eq("First name is too short (minimum is 1 character)")
      end

      it "should not update user last name if blank" do
        put :update_personal_info, params:{ user: { last_name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[1]).to eq("Last name is too short (minimum is 1 character)")
      end

      it "should not update very long user first name" do
        put :update_personal_info, params:{ user: { first_name: rand(36**201).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("First name is too long (maximum is 200 characters)")
      end

      it "should not update very long user last name" do
        put :update_personal_info, params:{ user: { last_name: rand(36**201).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Last name is too long (maximum is 200 characters)")
      end

      it "should not update very long user nickname" do
        put :update_personal_info, params:{ user: { nickname: rand(36**201).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Nickname is too long (maximum is 200 characters)")
      end

      it "should not update very long phone number" do
        put :update_personal_info, params:{ user: { phone: rand(36**21).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Phone is too long (maximum is 20 characters)")
      end

      it "should not update very long skype" do
        put :update_personal_info, params:{ user: { skype: rand(36**51).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Skype is too long (maximum is 50 characters)")
      end

      it "should not update very long status" do
        put :update_personal_info, params:{ user: { status: rand(36**51).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Status is too long (maximum is 50 characters)")
      end

      it "should not update very long country" do
        put :update_personal_info, params:{ user: { country: rand(36**51).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Country is too long (maximum is 50 characters)")
      end

      it "should not update very long city" do
        put :update_personal_info, params:{ user: { city: rand(36**51).to_s(36) } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("City is too long (maximum is 50 characters)")
      end
    end
  end

  describe "PUT 'update_privacy'" do
    context "correct params format" do
      it "should update user privacy settings to visible for all and returns a successful response" do
        put :update_privacy, params:{ user: { show_phones: 'all', show_skype: 'all', show_country: 'all',
                                                       show_city: 'all', show_status: 'all' } }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.show_phones).to eq("all")
        expect(@user.settings.show_skype).to eq("all")
        expect(@user.settings.show_country).to eq("all")
        expect(@user.settings.show_city).to eq("all")
        expect(@user.settings.show_status).to eq("all")
      end

      it "should update user privacy settings to visible for followers and returns a successful response" do
        put :update_privacy, params:{ user: { show_phones: 'followers', show_skype: 'followers', show_country: 'followers',
                                                       show_city: 'followers', show_status: 'followers' } }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.show_phones).to eq("followers")
        expect(@user.settings.show_skype).to eq("followers")
        expect(@user.settings.show_country).to eq("followers")
        expect(@user.settings.show_city).to eq("followers")
        expect(@user.settings.show_status).to eq("followers")
      end

      it "should update user privacy settings to hidden and returns a successful response" do
        put :update_privacy, params:{ user: { show_phones: 'hidden', show_skype: 'hidden', show_country: 'hidden',
                                                       show_city: 'hidden', show_status: 'hidden' } }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.show_phones).to eq("hidden")
        expect(@user.settings.show_skype).to eq("hidden")
        expect(@user.settings.show_country).to eq("hidden")
        expect(@user.settings.show_city).to eq("hidden")
        expect(@user.settings.show_status).to eq("hidden")
      end
    end

    context "incorrect params format" do
      it "should not update user phones privacy settings to incorrect" do
        put :update_privacy, params:{ user: { show_phones: 'no' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("'no' is not a valid show_phones")
      end

      it "should not update user skype privacy settings to incorrect" do
        put :update_privacy, params:{ user: { show_skype: 'no' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("'no' is not a valid show_skype")
      end

      it "should not update user country privacy settings to incorrect" do
        put :update_privacy, params:{ user: { show_country: 'no' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("'no' is not a valid show_country")
      end

      it "should not update user city privacy settings to incorrect" do
        put :update_privacy, params:{ user: { show_city: 'no' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("'no' is not a valid show_city")
      end

      it "should not update user status privacy settings to incorrect" do
        put :update_privacy, params:{ user: { show_status: 'no' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq("'no' is not a valid show_status")
      end
    end
  end

  describe "PUT 'update_language'" do
    context "correct params format" do
      it "should update user language to english" do
        put :update_language, params:{ language: 'en' }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.language).to eq("en")
      end

      it "should update user language to russian" do
        put :update_language, params:{ language: 'ru' }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.language).to eq("ru")
      end

      it "should update user language to espanol" do
        put :update_language, params:{ language: 'es' }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.language).to eq("es")
      end

      it "should update user language to arabic" do
        put :update_language, params:{ language: 'ar' }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.language).to eq("ar")
      end

      it "should update user language to chinese" do
        put :update_language, params:{ language: 'zh' }, format: :json
        expect(response).to have_http_status(:success)
        expect(@user.settings.language).to eq("zh")
      end
    end

    context "incorrect params format" do
      it "should not update user language not in list" do
        put :update_language, params:{ language: 'de' }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]).to eq("Language is not included in the list")
      end
    end
  end
end