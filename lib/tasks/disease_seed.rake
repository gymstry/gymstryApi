unless Rails.env.production?
  namespace :db do
    namespace :disease_seed do
      desc "Generator to create diseases"
      task create_diseases: :environment do
        require 'faker'
        a = (10..50).to_a.sample
        100.times do |index|
          Disease.create(
            name: Faker::Name.unique.first_name,
            description: Faker::Lorem.characters(a)
          )
        end
      end

    end
  end
end
