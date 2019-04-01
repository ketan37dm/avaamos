FactoryBot.define do 
  factory :event do 
    title { 'sample' }
    start_time { Time.now - 5.hours }
    end_time { Time.now - 2.hours }
    description { 'Some description' }
    all_day { true }
    rsvps { 'ketan#yes;chinmay#maybe' }
    completed { true }
  end 
end