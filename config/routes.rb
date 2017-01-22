Rails.application.routes.draw do
  mount_devise_token_auth_for 'Gym', at: 'api/v1/gym_auth', skip: [:omniauth_callbacks]

  mount_devise_token_auth_for 'Branch', at: 'api/v1/branch_auth', skip: [:omniauth_callbacks,:confirmations], controllers: {
    registrations:  'overrides/registrations'
  }

  mount_devise_token_auth_for 'Trainer', at: 'api/v1/trainer_auth', skip: [:omniauth_callbacks]

  mount_devise_token_auth_for 'User', at: 'api/v1/auth', skip: [:omniauth_callbacks], controllers: {
    registrations:  'overrides/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
