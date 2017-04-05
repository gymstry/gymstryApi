unless Rails.env.production?
  namespace :db do
    namespace :user_seed do
      desc "Generator to create users"
      task create_users: :environment do
        require 'faker'
        branches = Branch.all
        a = (10..300).to_a
        b = (0..1).to_a
        100.times do |index|
          u = User.new(
            name: Faker::Name.first_name,
            lastname: Faker::Name.last_name,
            mobile: Faker::Number.unique.number(10),
            email: Faker::Internet.unique.email,
            birthday: Faker::Date.birthday(1, 30),
            remaining_days: a.sample,
            objective: Faker::Lorem.characters(30),
            gender: b.sample,
            username: Faker::Lorem.unique.characters(10),
            password: "gutierrez2011",
            password_confirmation: "gutierrez2011"
          )
          u.remote_avatar_url = "https://www.w3schools.com/css/trolltunga.jpg"
          u.branch_id = branches.sample.id
          u.save
        end
      end

    end
  end
end
