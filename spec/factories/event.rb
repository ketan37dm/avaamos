FactoryBot.define do 
  factory :event do 
    title { Faker::Name.name }
    start_time { Time.now - 5.hours }
    end_time { Time.now - 2.hours }
    description { Faker::Quote.famous_last_words }
    all_day { false }
    rsvps { 'ketan#yes;chinmay#maybe' }
    completed { true }
  end 
end