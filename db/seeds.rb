require 'csv'

# Populate Users
user_creation_errors = {}
count = 0
CSV.foreach('db/seed_data/users.csv', headers: true) do |row|
  begin
    user = User.new(row.to_h)
    user.save!
    count += 1
  rescue StandardError => e
    user_creation_errors[row['username']] = e.message
  end
end

puts "#{count} users created successfully"
if user_creation_errors.present?
  puts "Following are the errors"
  puts user_creation_errors.inspect
end
