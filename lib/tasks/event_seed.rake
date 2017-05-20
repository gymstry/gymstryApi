unless Rails.env.production?
  namespace :db do
    namespace :event_seed do
      desc "Generator to create events"
      task create_events: :environment do
        require 'faker'
        b = Branch.all
        a = (0..3).to_a
        c = [:TRX,:yoga,:force,:other]
        100.times do |index|
          e = Event.new(
            name: Faker::Name.unique.first_name,
            description: Faker::Lorem.characters(15),
            class_date: Date.today + a.sample,
            duration: 2,
            type_event: Event.type_events[c[a.sample]]

          )
          e.remote_image_url = "https://www.w3schools.com/css/trolltunga.jpg"
          e.branch_id = b.sample.id
          e.save
        end
      end

    end
  end
end
