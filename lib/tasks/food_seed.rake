unless Rails.env.production?
  namespace :db do
    namespace :food_seed do
      desc "Generator to create foods"
      task create_foods: :environment do
        require 'faker'
        a = (10..120).to_a
        100.times do |index|
          f = Food.new(
            name: Faker::Name.unique.first_name,
            description: Faker::Lorem.characters(20),
            proteins: a.sample,
            carbohydrates: a.sample,
            fats: a.sample
          )
          f.remote_image_url = "https://www.w3schools.com/css/trolltunga.jpg"
          f.save
        end
      end
    end
  end

end
