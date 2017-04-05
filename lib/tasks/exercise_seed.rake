unless Rails.env.production?
  namespace :db do
    namespace :exercise_seed do
      desc "Generator to create exercises"
      task create_exercises: :environment do
        m = (0..2).to_a
        trainers = Trainer.all
        100.times do |index|
          e = Exercise.new(
            name: Faker::Name.first_name,
            description: Faker::Lorem.characters(20),
            problems: Faker::Lorem.characters(20),
            benefits: Faker::Lorem.characters(20),
            muscle_group: m.sample,
            elements: ["some elements","some elements1"],
            level: m.sample
          )
          if m.sample == 0
            e.trainer_id = trainers.sample.id
            e.owner = "trainer"
          end
          e.save
        end
      end
    end
  end
end
