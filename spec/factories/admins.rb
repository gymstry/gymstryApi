FactoryGirl.define do
  factory :admin do
    name  { Faker::Name }
    email { Faker::Internet.unique.email }
    username { Faker::Lorem.unique.characters(10) }
    password "gutierrez2011"
    password_confirmation "gutierrez2011"
  end
end
