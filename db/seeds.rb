require 'csv'
require 'fileutils'

FileUtils.mkdir('tmp/seed_data') unless File.exists?('tmp/seed_data')

USER_FILEPATH = 'db/seed_data/users.csv'
USER_ERRORS_FILEPATH = 'tmp/seed_data/users_errors.csv'
EVENT_FILEPATH = 'db/seed_data/events.csv'
EVENT_ERRORS_FILEPATH = 'tmp/seed_data/event_errors.csv'

class UserCreationError < StandardError; end
class EventCreationError < StandardError; end 

%w(user event).each do |entity|
	define_method("#{entity}_errors_file")  do 
		file_var = instance_eval("@#{entity}_errors_file")
		return file_var if file_var
		file = CSV.read(
			instance_eval("#{entity.upcase}_FILEPATH"),
			headers: true, 
			return_headers: true
		)
		headers = file.headers + ['errors']
		file_var ||= CSV.open(
			instance_eval("#{entity.upcase}_ERRORS_FILEPATH"), 'w', headers: headers
		)
		file_var << headers
		file_var
	end 

	define_method("populate_#{entity}") do 
		errors_file = instance_eval("#{entity}_errors_file")
		CSV.foreach(instance_eval("#{entity.upcase}_FILEPATH"), headers: true) do |row|
			row = row.to_h
		  begin
		  	attrs = {}
		  	if (entity == 'event')
		  		attrs['title'] = row['title']
		  		attrs['start_time'] = row['starttime']
		  		attrs['end_time'] = row['endtime']
		  		attrs['description'] = row['description']
		  		attrs['rsvps'] = row['users#rsvp']
		  		attrs['all_day'] = (row['allday'] == 'TRUE')
		  	else 
		  		attrs = row
		  	end 
		    object = "#{entity.classify}".constantize.new(attrs)
		    if object.valid?
		    	object.save!
		    else
		    	raise "#{entity.camelize}CreationError".constantize.new(object.errors.full_messages.join(', '))
		    end
		  rescue StandardError => e
		  	row['errors'] = e.message
		  	errors_file << row
		  end
		end
		errors_file.close
	end 
end 

populate_user
populate_event
RsvpResolverService.new.execute

