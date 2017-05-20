unless Rails.env.production?
  namespace :db do
    namespace :challenge_seed do
      desc "Generator to create challenges"
      task create_challenges: :environment do
        require 'faker'
        users = User.all
        trainers = Trainer.all
        t = (0..7).to_a
        s = (0..2).to_a
        o = (10..100).to_a
        100.times do |index|
          c = Challange.new(
            name: Faker::Name.first_name,
            description: Faker::Lorem.characters(20),
            type_challange: t.sample,
            start_date: Faker::Date.between(50.days.ago, Date.today + 10),
            end_date: Faker::Date.between(Date.today + 20, Date.today + 50),
            state: s.sample,
            objective: o.sample
          )
          c.user_id = users.sample.id
          c.trainer_id = trainers.sample.id
          c.save
        end
      end

    end
  end
end
