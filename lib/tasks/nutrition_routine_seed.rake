unless Rails.env.production?
  namespace :db do
    namespace :nutrition_routine_seed do
      desc "Generator to create nutrition_routines"
      task create_nutrition_routines: :environment do
        require 'faker'
        a = (-50..50).to_a
        b = (51..120).to_a
        users = User.all
        trainers = Trainer.all
        100.times  do |index|
          n = NutritionRoutine.new(
            name: Faker::Name.unique.first_name,
            description: Faker::Lorem.characters(20),
            objective: Faker::Lorem.characters(20),
            start_date: Date.today + a.sample,
            end_date: Date.today + b.sample
          )
          n.user_id = users.sample.id
          n.trainer_id = trainers.sample.id
          n.save
        end
      end
    end

  end
end
