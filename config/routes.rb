Rails.application.routes.draw do

  # Registration & Authentication
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:passwords], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations:      'users/registrations',
    sessions:           'users/sessions',
    token_validations:  'users/token_validations'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v3 do

      # Posts & Post comments & Post likes
      resources :posts do
        resources :comments, except: :show
        post 'like', to: 'likes#like'
        post 'get_likes_names', to: 'likes#get_names'
      end

      # Comment replies
      resources :comments, only: [] do
        resources :comments, except: :show
        post 'like', to: 'likes#like'
      end

      # Groups
      resources :groups do
        get 'get_users',                 to: 'groups#get_users'
        post 'add_user/:user_id',        to: 'groups#add_user'
        delete 'delete_user/:user_id',   to: 'groups#delete_user'
        put 'change_user_role/:user_id', to: 'groups#change_user_role'
      end

      # Followers
      get 'followings/:user_id',         to: 'follows#get_followings'
      get 'followers/:user_id',          to: 'follows#get_followers'
      post 'follow/:user_id',            to: 'follows#create'
      delete 'unfollow/:user_id',        to: 'follows#destroy'

      # Favorites
      get 'favorites',                   to: 'favorites#index'
      put 'favorites',                   to: 'favorites#update'

      # User settings
      put 'update_personal_info',        to: 'user_settings#update_personal_info'
      put 'update_privacy',              to: 'user_settings#update_privacy'
      put 'update_language',             to: 'user_settings#update_language'
      get 'get_user_info/:user_id',      to: 'user_settings#get_user_info'

      # Link parser
      post 'parse_url',                  to: 'parse#parse_url'
    end
  end

  # API documentation
  apipie
end
