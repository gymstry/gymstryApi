FactoryGirl.define do
  factory :branch do
    name  { Faker::Name }
    email { Faker::Internet.unique.email }
    address { Faker::Address.street_address }
    telephone { Faker::Number.unique.number(10) }
    password "gutierrez2011"
    password_confirmation "gutierrez2011"
  end
end
