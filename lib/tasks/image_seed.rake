unless Rails.env.production?
  namespace :db do
    namespace :image_seed do
      desc "Generator to create images"
      task create_images: :environment do
        exercises = Exercise.all
        gyms = Gym.all
        a = (0..4).to_a
        require 'faker'
        100.times do |index|
          i = Image.new(
            description: Faker::Lorem.characters(15)
          )
          i.remote_image_url = "https://www.w3schools.com/css/trolltunga.jpg"
          if a.sample < 1
            gym = gyms.sample
            gym.images<< i
            i.save
            gym.save
          else
            exercise = exercises.sample
            exercise.images<< i
            i.save
            exercise.save
          end
        end
      end
    end
  end
end
