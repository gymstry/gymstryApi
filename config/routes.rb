Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resource :admins, only: [:show,:index,:destroy] do
        collection  do
          get 'admin-by-email', to: "admins#admin_by_email"
          get 'admin-by-username', to: "admins#admin_by_username"
          get 'admins-by-name', to: "admins#admins_by_name"
          get 'admins-by-ids', to: "admins#admins_by_ids"
          get 'admins-by-not-ids', to: "admins#admins_by_not_ids"
        end
      end
      controller :facebook do
        post 'login-facebook', to: "facebook#login_facebook"
      end
      resources :gyms, only: [:index,:show,:destroy] do
        collection do
          get 'gym-by-email', to: "gyms#gym_by_email"
          get 'gyms-by-name', to: "gyms#gyms_by_name"
          get 'gyms-by-ids', to: "gyms#gyms_by_ids"
          get 'gyms-by-not-ids', to: "gyms#gyms_by_not_ids"
          get 'gyms-with-branches', to: "gyms#gyms_with_branches"
          get 'gyms-with-pictures', to: "gyms#gyms_with_pictures"
          get 'gyms-by-speciality', to: "gyms#gyms_by_speciality"
        end
        resources :branches, only: [:index] do
          collection do
            get 'branch-by-email', to: "branches#branch-by-email"
            get 'branches-with-events', to: "branches#branches_with_events"
            get 'branches-with-trainers', to: "branches#branches_with_trainers"
            get 'branches-with-timetables', to: "branchs#branches_with_timetables"
            get 'branches-with-users', to: "branches#branches_with_users"
            get 'branches-with-events-date', to: "branches#branches_with_events_range"
          end
        end
      end
      resources :branches, only: [:index,:show,:destroy] do
        resources :trainers, only: [:index] do
          collection do
            get 'trainers-by-name', to: "trainers#trainers_by_name"
            get 'trainers-by-lastname', to: "trainers#trainers_by_lastname"
            get 'trainers-by-username-or-email', to: "trainers#trainers_by_username_or_email"
            get 'trainers_by_birthday', to: "trainers#trainers_by_birthday"
            get 'trainers-by-speciality', to: "trainers#trainers_by_speciality"
            get 'trainers-with-qualifications', to: "trainers#trainers_with_qualifications"
            get 'trainers-with-challenges', to: "trainers#trainers_with_challanges"
            get 'trainers-with-measurements', to: "trainers#trainers_with_measurements"
            get 'trainers-with-nutrition-routines', to: "trainers#trainers_with_nutrition_routines"
            get 'trainers-with-workouts', to: "trainers#trainers_with_workouts"
          end
        end
        resources :users, only: [:index] do
          get 'male', to: "users#users_male"
          get 'female', to: "users#users_female"
          get 'users-by-name', to: "users#users_by_name"
          get 'users-by-lastname', to: "users#users_by_lastname"
          get 'users-by-username-or-email', to: "users#users_by_username_or_email"
          get 'users-by-birthday', to: "users#users_by_birthday"
          get 'users-with-challenges', to: "users#users_with_challenges"
          get 'users-with-measurements', to: "users#users_with_measurements"
          get 'users-with-nutrition-routines', to: "users#users_with_nutrition_routines"
          get 'users-with-workouts', to: "users#users_with_workouts"
        end
        collection do
          get 'branch-by-email', to: "branches#branch_by_email"
          get 'branches-by-ids', to: "branches#branches_by_ids"
          get 'branches-by-not-ids', to: "branches#branches_by_not_ids"
          get 'branches-with-events', to: "branches#branches_with_events"
          get 'branches-with-trainers', to: "branches#branches_with_trainers"
          get 'branches-with-timetables', to: "branchs#branches_with_timetables"
          get 'branches-with-users', to: "branches#branches_with_users"
          get 'branches-with-events-date', to: "branches#branches_with_events_range"
        end
      end
      resources :trainers, only: [:index,:show,:destroy] do
        collection do
          get 'trainers-by-ids', to: "trainers#trainers_by_ids"
          get 'trainers-by-not-ids', to: "trainers#trainers_by_not_ids"
          get 'trainer-by-username', to: "trainers#trainer_by_username"
          get 'trainer-by-eamil', to: "trainers#trainer_by_email"
          get 'trainers-by-name', to: "trainers#trainers_by_name"
          get 'trainers-by-lastname', to: "trainers#trainers_by_lastname"
          get 'trainers-by-username-or-email', to: "trainers#trainers_by_username_or_email"
          get 'trainers_by_birthday', to: "trainers#trainers_by_birthday"
          get 'trainers-by-speciality', to: "trainers#trainers_by_speciality"
          get 'trainers-with-qualifications', to: "trainers#trainers_with_qualifications"
          get 'trainers-with-challenges', to: "trainers#trainers_with_challanges"
          get 'trainers-with-measurements', to: "trainers#trainers_with_measurements"
          get 'trainers-with-nutrition-routines', to: "trainers#trainers_with_nutrition_routines"
          get 'trainers-with-workouts', to: "trainers#trainers_with_workouts"
        end
      end
      resources :users, only: [:index,:show,:destroy] do
        collection do
          get 'male', to: "users#users_male"
          get 'female', to: "users#users_female"
          get 'users-by-ids', to: "users#users_by_ids"
          get 'users-by-not-ids', to: "users#users_by_not_ids"
          get 'user-by-email', to: "users#user_by_email"
          get 'user-by-username',to: "users#user_by_username"
          get 'users-by-name', to: "users#users_by_name"
          get 'users-by-lastname', to: "users#users_by_lastname"
          get 'users-by-username-or-email', to: "users#users_by_username_or_email"
          get 'users-by-birthday', to: "users#users_by_birthday"
          get 'users-with-challenges', to: "users#users_with_challenges"
          get 'users-with-measurements', to: "users#users_with_measurements"
          get 'users-with-nutrition-routines', to: "users#users_with_nutrition_routines"
          get 'users-with-workouts', to: "users#users_with_workouts"
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
