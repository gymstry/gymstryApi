unless Rails.env.production?
  namespace :db do
    namespace :gym_seed do
      desc "Generator to create gyms"
      task create_gyms: :environment do
        require 'faker'
        a = ["TRX", "crossfit"]
        100.times do |index|
          Gym.create(
            name: Faker::Name.unique.first_name,
            description:Faker::Lorem.unique.characters(30),
            email: Faker::Internet.unique.email,
            password: "gutierrez2011",
            password_confirmation: "gutierrez2011",
            address: Faker::Address.unique.street_address,
            telephone: Faker::Number.unique.number(10),
            speciality: [a.sample],
            birthday: Faker::Date.birthday(1, 30)
          )
        end
      end
    end
  end
end
