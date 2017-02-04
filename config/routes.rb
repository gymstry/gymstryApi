Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      controller :facebook do
        post 'login-facebook', to: "facebook#login_facebook"
      end
      resources :gyms, only: [:index,:show] do
        collection do
          get 'gym-by-email', to: "gyms#gym_by_email"
          get 'gyms-by-name', to: "gyms#gyms_by_name"
          get 'gyms-by-ids', to: "gyms#gyms_by_ids"
          get 'gyms-by-not-ids', to: "gyms#gyms_by_not_ids"
          get 'gyms-with-branches', to: "gyms#gyms_with_branches"
          get 'gyms-with-pictures', to: "gyms#gyms_with_pictures"
        end
        resources :branches, only: [:index] do
          collection do
            get 'branch-by-email', to: "gyms#branch-by-email"
            get 'branches-with-events-date', to: "gyms#branches_with_events_range"
          end
        end
      end
      resources :branches, only: [:index,:show,:destroy] do
        collection do
          get 'branch-by-email', to: "gyms#branch_by_email"
          get 'branches-by-ids', to: "gyms#branches_by_ids"
          get 'branches-by-not-ids', to: "gyms#branches_by_not_ids"
          get 'branches-with-events', to: "gyms#branches_with_events"
          get 'branches-with-trainers', to: "gyms#branches_with_trainers"
          get 'branches-with-users', to: "gyms#branches_with_users"
          get 'branches-with-events-date', to: "gyms#branches_with_events_range"
        end
      end
    end
  end

  mount_devise_token_auth_for 'Gym', at: 'api/v1/gym_auth', skip: [:omniauth_callbacks], controllers: {
    registrations: 'overrides/registrations_gym_and_trainer'
  }

  mount_devise_token_auth_for 'Branch', at: 'api/v1/branch_auth', skip: [:omniauth_callbacks,:confirmations], controllers: {
    registrations:  'overrides/registrations'
  }

  mount_devise_token_auth_for 'Trainer', at: 'api/v1/trainer_auth', skip: [:omniauth_callbacks], controllers: {
    registrations: 'overrides/registrations_gym_and_trainer'
  }

  mount_devise_token_auth_for 'User', at: 'api/v1/auth', skip: [:omniauth_callbacks], controllers: {
    registrations:  'overrides/registrations'
  }
  mount_devise_token_auth_for 'Admin', at: 'api/v1/admin_auth', skip: [:omniauth_callbacks, :confirmations]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
