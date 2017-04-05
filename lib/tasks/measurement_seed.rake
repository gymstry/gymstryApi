unless Rails.env.production?
  namespace :db do
    namespace :measurement_seed do
      desc "Generator to create measurements"
      task create_measurements: :environment do
        a = (10..100).to_a
        users = User.all
        trainers = Trainer.all
        100.times do |index|
          m = Measurement.create(
            weight: a.sample,
            hips: a.sample,
            chest: a.sample,
            body_fat_percentage: a.sample,
            waist: a.sample,
            user_id: users.sample.id,
            trainer_id: trainers.sample.id
          )
        end
      end
    end
  end
end
