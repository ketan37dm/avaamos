FactoryBot.define do 
  factory :user do 
    username { Faker::Alphanumeric.alpha 10 }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
  end 
end 