unless Rails.env.production?
  namespace :db do
    namespace :admin_seed do
      desc "Generator to create admins"
      task create_admins: :environment do
        require 'faker'
        #Rake::Task['db:reset'].invoke
        100.times do |index|
          Admin.create(
            name: Faker::Name.unique.first_name,
            username: Faker::Lorem.unique.characters(10),
            email: Faker::Internet.unique.email,
            password: "gutierrez2011",
            password_confirmation: "gutierrez2011"
          )
        end
      end

    end
  end
end
