unless Rails.env.production?
  namespace :db do
    namespace :branch_seed do
      desc "Generator to create branches"
      task create_branches: :environment do
        require 'faker'
        gyms = Gym.all
        100.times do |index|
          b = Branch.new(
            name: Faker::Name.unique.first_name,
            email: Faker::Internet.unique.email,
            address: Faker::Address.street_address,
            telephone: Faker::Number.unique.number(10),
            password: "gutierrez2011",
            password_confirmation: "gutierrez2011"
          )
          b.gym_id = gyms.sample.id
          b.save
        end
      end
    end
  end
end
