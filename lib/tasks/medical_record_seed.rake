unless Rails.env.production?
  namespace :db do
    namespace :medical_record_seed do
      desc "Generator to create medical_records"
      task create_medical_records: :environment do
        require 'faker'
        a = (10..100).to_a
        users = User.all
        100.times do |index|
          m = MedicalRecord.create(
            weight: a.sample,
            hips: a.sample,
            chest: a.sample,
            body_fat_percentage: a.sample,
            waist: a.sample,
            user_id: users.sample.id,
            observation: Faker::Lorem.characters(30),
            medication: Faker::Lorem.characters(30)
          )
        end
      end

    end

  end
end
