class RsvpResolverService
  def execute
    sorted_events.find_in_batches(batch_size: 500).each do |batch|
      batch.each do |current_event|
        hashed_rsvps = current_event.hashed_rsvps
        users = User.where(username: hashed_rsvps.keys)
        users.each do |user|
          rsvp = hashed_rsvps[user.username]
          registration = Registration.create(user: user, event: current_event, rsvp: rsvp)
          if rsvp == 'yes'
            latest_reg = Registration.includes(:event).find_by(id: user.latest_reg_id)
            if latest_reg && overlapping_events?(latest_reg.event, current_event)
              latest_reg.update_attributes(rsvp: 'no')
            end 
            user.update_latest_reg_id(registration.id)
          end
        end 
      end 
    end 
  end 

  private 

  def sorted_events
    Event.order('start_time asc')
  end 

  def overlapping_events?(latest_event, current_event)
    if latest_event.all_day?
      (current_event.start_time >= latest_event.start_time) && 
        (current_event.start_time.to_date <= latest_event.end_time.to_date)
    else
      (current_event.start_time < latest_event.end_time) && 
        (current_event.start_time >= latest_event.start_time)
    end 
  end 
end 