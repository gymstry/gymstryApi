Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :admins, only: [:show,:index,:destroy] do
        collection  do
          get 'admins-by-search', to: "admins#admins_by_search"
          get 'admins-by-ids', to: "admins#admins_by_ids"
          get 'admins-by-not-ids', to: "admins#admins_by_not_ids"
        end
      end
      #controller :facebook do
      #  post 'login-facebook', to: "facebook#login_facebook"
      #end
      resources :users, only: [] do
        resources :diseases, only: [] do
          collection do
            get 'diseases-by-user', to: "diseases#diseases_by_user"
          end
        end
        resources :trainers, only: []  do
          resources :nutrition_routines, only: [:index] do
            collection do
              get 'nutrition-routines-by-start-date', to: "nutrition_routines#nutrition_routines_by_start_date"
              get 'nutrition-routines-by-end-date', to: "nutrition_routines#nutrition_routines_by_end_date"
            end
          end
          resources :challanges, only: [:index] do
            collection do
              get 'challenges-by-start-date', to: "challanges#challanges_by_start_date"
              get 'challenges-by-end_date', to: "challanges#challanges_by_end_date"
            end
          end
          #match 'challenges', to: "challanges#challanges", via: [:get]
        end
      end
      resources :gyms, only: [:index,:show,:destroy] do
        resources :images, only: [:index,:create,:update,:destroy]
        collection do
          #get 'gym-by-email', to: "gyms#gym_by_email"
          get 'gyms-by-search', to: "gyms#gyms_by_search"
          get 'gyms-by-ids', to: "gyms#gyms_by_ids"
          get 'gyms-by-not-ids', to: "gyms#gyms_by_not_ids"
          get 'gyms-with-branches', to: "gyms#gyms_with_branches"
          get 'gyms-with-pictures', to: "gyms#gyms_with_pictures"
          get 'gyms-with-offers', to: "gyms#gyms_with_offers"
          get 'gyms-by-speciality', to: "gyms#gyms_by_speciality"
          get 'gyms-with-offers-and-date', to: "gyms#gyms_with_offers_and_date"
        end
        resources :branches, only: [:index] do
          collection do
            get 'branches-by-search', to: "branches#branches_by_search"
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
        resources :events, only: [:index] do
          collection do
            get 'events-by-search', to: "events#events_by_search"
            get 'events-by-date', to: "events#events_by_date"
            get 'events-by-type-event-and-date', to: "events#events_by_type_event_and_date"
            get 'events-by-type-event', to: "events#events_by_type_event"
            get 'events-by-type-event-and-date', to: "events#events_by_type_event_and_date"
          end
        end
        resources :users, only: [:index] do
          resources :medical_record, only: [:index,:create]
          collection do
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
        end
        collection do
          get 'branches-by-search', to: "branches#branches_by_search"
          get 'branches-by-ids', to: "branches#branches_by_ids"
          get 'branches-by-not-ids', to: "branches#branches_by_not_ids"
          get 'branches-with-events', to: "branches#branches_with_events"
          get 'branches-with-trainers', to: "branches#branches_with_trainers"
          get 'branches-with-timetables', to: "branches#branches_with_timetables"
          get 'branches-with-users', to: "branches#branches_with_users"
          get 'branches-with-events-date', to: "branches#branches_with_events_range"
        end
      end
      resources :events do
        collection do
          get 'events-by-search', to: "events#events_by_search"
          get 'events-by-ids', to: "events#events_by_ids"
          get 'events-by-not-ids', to: "events#events_by_not_ids"
          get 'events-by-date', to: "events#events_by_date"
          get 'events-by-type-event', to: "events#events_by_type_event"
          get 'events-by-type-event-and-date', to: "events#events_by_type_event_and_date"

        end
      end
      resources :trainers, only: [:index,:show,:destroy] do
        resources :nutrition_routines, only: [:index] do
          collection do
            get 'nutrition-routines-by-start-date', to: "nutrition_routines#nutrition_routines_by_start_date"
            get 'nutrition-routines-by-end-date', to: "nutrition_routines#nutrition_routines_by_end_date"
          end
        end
        resources :measurements, only: [:index] do
          collection do
            get 'measurements-by-date', to: "measurements#measurements_by_date"
          end
        end
        resources :images, only: [:index,:create,:update,:destroy]
        resources :exercises, only: [:index] do
           collection do
             get 'exercises-by-search', to: "exercises#exercises_by_search"
             get 'exercises-available-user', to: "exercises#exercises_available_user"
           end
        end
        resources :challanges, only: [:index] do
          collection do
            get 'challenges-by-type', to: "challanges#challanges_by_type"
            get 'challenges-by-state', to: "challanges#challanges_by_state"
            get 'challenges-by-start-date',to: "challanges#challanges_by_start_date"
            get 'challenges-by-end-date', to: "challanges#challanges_by_end_date"
            #get 'challenges', to: "challanges#challanges"
          end
        end
        collection do
          get 'trainers-by-ids', to: "trainers#trainers_by_ids"
          get 'trainers-by-not-ids', to: "trainers#trainers_by_not_ids"
          get 'trainers-by-search', to: "trainers#trainers_by_search"
          get 'trainers-by-birthday', to: "trainers#trainers_by_birthday"
          get 'trainers-by-speciality', to: "trainers#trainers_by_speciality"
          get 'trainers-with-qualifications', to: "trainers#trainers_with_qualifications"
          get 'trainers-with-challenges', to: "trainers#trainers_with_challanges"
          get 'trainers-with-measurements', to: "trainers#trainers_with_measurements"
          get 'trainers-with-nutrition-routines', to: "trainers#trainers_with_nutrition_routines"
          get 'trainers-with-workouts', to: "trainers#trainers_with_workouts"
        end
      end
      resources :users, only: [:index,:show,:destroy] do
        resources :nutrition_routines, only: [:index,:create] do
          collection do
            get 'nutrition-routines-by-start-date', to: "nutrition_routines#nutrition_routines_by_start_date"
            get 'nutrition-routines-by-end-date', to: "nutrition_routines#nutrition_routines_by_end_date"
          end
        end
        resources :measurements, only: [:index] do
          collection do
            get 'measurements-by-date', to: "measurements#measurements_by_date"
          end
        end
        resources :challanges, only: [:index,:create] do
          collection do
            get 'challenges-by-type', to: "challanges#challanges_by_type"
            get 'challenges-by-state', to: "challanges#challanges_by_state"
            get 'challenges-by-start-date',to: "challanges#challanges_by_start_date"
            get 'challenges-by-end-date', to: "challanges#challanges_by_end_date"
            #get 'challenges', to: "challanges#challanges"
          end
        end
        collection do
          get 'male', to: "users#male"
          get 'female', to: "users#female"
          get 'users-by-ids', to: "users#users_by_ids"
          get 'users-by-not-ids', to: "users#users_by_not_ids"
          get 'users-by-search', to: "users#users_by_search"
          get 'users-by-birthday', to: "users#users_by_birthday"
          get 'users-with-challenges', to: "users#users_with_challenges"
          get 'users-with-measurements', to: "users#users_with_measurements"
          get 'users-with-nutrition-routines', to: "users#users_with_nutrition_routines"
          get 'users-with-workouts', to: "users#users_with_workouts"
        end
      end
      resources :challanges, only: [:index,:show,:destroy,:update] do
        collection do
          get 'challenges-by-ids', to: "challanges#challanges_by_ids"
          get 'challenges-by-not-ids', to: "challanges#challanges_by_not_ids"
          get 'challenges-by-search', to: "challanges#challanges_by_search"
          get 'challenges-by-type', to: "challanges#challanges_by_type"
          get 'challenges-by-state', to: "challanges#challanges_by_state"
          get 'challenges-by-start-date',to: "challanges#challanges_by_start_date"
          get 'challenges-by-end-date', to: "challanges#challanges_by_end_date"
        end
      end
      resources :diseases do
        collection do
          get 'diseases-by-search', to: "diseases#diseases_by_search"
          get 'diseases-by-ids', to: "diseases#diseases_by_ids"
          get 'diseases-by-not-ids', to: "diseases#diseases_by_not_ids"
          get 'diseases-with-medical-records', to: "diseases#diseases_with_medical_records"
        end
      end

      resources :exercises do
        member do
          get 'add-images', to: "exercises#add_images"
        end
        collection do
          get 'exercises-by-search', to: "exercises#exercises_by_search"
          get 'exercises-by-ids', to: "exercises#exercises_by_ids"
          get 'exercises-by-not-ids', to: "exercises#exercises_by_not_ids"
          get 'exercises-with-images', to: "exercises#exercises_with_images"
          get 'exercises-with-medical-records', to: "exercises#exercises_with_medical_records"
          get 'exercises-with-routines', to: "exercises#exercises_with_routines"
          get 'exercises-available-user', to: "exercises#exercises_available_user"
        end
      end

      resources :workouts do
        resources :exercises, only: [:index] do
          collection do
            get 'exercises-by-workout-per-day', to: "exercises#exercises_by_workout_per_day"
          end
        end
      end

      resources :food_days, only: [:index,:update,:show,:destroy] do
        resources :foods, only: [:index]
        collection do
          get 'food-days-by-ids', to: "food_days#food_days_by_ids"
          get 'food-days-by-not-ids', to: "food_days#food_days_by_not_ids"
          get 'food-days-with-foods', to: "food_days#food_days_with_foods"
          get 'food_days_by_type', to: "food_days#food_days_by_type"
        end
      end
      resources :nutrition_routines, only: [:index,:show,:update,:destroy] do
        collection do
          get 'nutrition-routines-by-search', to: "nutrition_routines#nutrition_routines_by_search"
          get 'nutrition-routines-by-ids', to: "nutrition_routines#nutrition_routines_by_ids"
          get 'nutrition-routines-by-not-ids',to: "nutrition_routines#nutrition_routines_by_not_ids"
          get 'nutrition-routines-by-start-date', to: "nutrition_routines#nutrition_routines_by_start_date"
          get 'nutrition-routines-by-end-date', to: "nutrition_routines#nutrition_routines_by_end_date"
        end
        resources :food_days, only: [:index,:create] do
          collection do
            get 'food_days_by_type', to: "food_days#food_days_by_type"
          end
        end
      end

      resources :medical_records, only: [:index,:show,:update,:destroy] do
        collection do
          get 'medical-records-by-ids', to: "medical_records#medical_records_by_ids"
          get 'medical-records-by-not-ids', to: "medical_records#medical_records_by_not_ids"
          get 'medical-records-with-diseases', to: "medical_records#medical_records_with_diseases"
          get 'prohibited-exercises', to: "medical_records#medical_records_with_exercises"
        end
        resources :disesases, only: [] do
          collection do
            get 'diseases-with-medical-records-by-id', to: "diseases#diseases_with_medical_records_by_id"
          end
        end
      end

      resources :foods do
        collection do
          get 'foods-by-search', to: "foods#foods_by_search"
          get 'foods-by-ids', to: "foods#foods_by_ids"
          get 'foods-by-not-ids', to: "foods#foods_by_not_ids"
          get 'foods-by-proteins-greater-than', to: "foods#foods_by_proteins_greater_than"
          get 'foods-by-carbohydrates-greater-than', to: "foods#foods_by_carbohydrates_greater_than"
          get 'foods-by-fats-greater-than', to: "foods#foods_by_fats_greater_than"
          get 'foods-with-food-days', to: "foods#foods_with_food_days"
        end
      end

      resources :images, only: [:index,:show] do
        collection do
          get 'images-by-ids', to: "images#images_by_ids"
          get 'images-by-not-ids', to: "images#images_by_not_ids"
        end

      end

      resources :measurements do
        collection do
          get 'measurements-by-ids', to: "measurements#measurements_by_ids"
          get 'measurements-by-not-ids', to: "measurements#measurements_by_not_ids"
          get 'measurements-by-date', to: "measurements#measurements_by_date"
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

  mount_devise_token_auth_for 'User', at: 'api/v1/auth', skip:[:omniauth_callbacks], controllers: {
    registrations:  'overrides/registrations',
  }
  mount_devise_token_auth_for 'Admin', at: 'api/v1/admin_auth', skip: [:omniauth_callbacks, :confirmations]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
