unless Rails.env.production?
  namespace :db do
    namespace :trainer_seed do
      desc "Generator to create trainers"
      task create_trainers: :environment do
        require 'faker'
        a = ["TRX", "crossfit"]
        b = (0..1).to_a
        c = [:gym,:personal_trainer]
        branches = Branch.all
        100.times do |index|
          t = Trainer.new(
            name: Faker::Name.first_name,
            lastname: Faker::Name.last_name,
            mobile: Faker::Number.unique.number(10),
            email: Faker::Internet.unique.email,
            speciality: [a.sample],
            type_trainer: Trainer.type_trainers[c[b.sample]],
            birthday: Faker::Date.birthday(1, 30),
            username: Faker::Lorem.unique.characters(10),
            password: "gutierrez2011",
            password_confirmation: "gutierrez2011"
          )
          t.remote_avatar_url = "https://www.w3schools.com/css/trolltunga.jpg"
          t.branch_id = branches.sample.id
          t.save
        end
      end
    end
  end

end
