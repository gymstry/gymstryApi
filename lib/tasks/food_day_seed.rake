unless Rails.env.production?
  namespace :db do
    namespace :food_day_seed do
      desc "Generator to create food_days"
      task create_food_days: :environment do
        require 'faker'
        nutrition_routines = NutritionRoutine.all
        a = (0..2).to_a
        100.times do |index|
          FoodDay.create(
            type_food: a.sample,
            description: Faker::Lorem.characters(20),
            benefits: Faker::Lorem.characters(20),
            nutrition_routine_id: nutrition_routines.sample.id
          )
        end
      end

    end
  end
end
