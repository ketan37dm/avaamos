class RsvpResolverService
  def execute
    sorted_events.each do |current_event|
      hashed_rsvps = current_event.hashed_rsvps
      users = User.where(username: hashed_rsvps.keys)
      users.each do |user|
        rsvp = hashed_rsvps[user.username]
        if rsvp == 'yes'
          latest_yes_event = UserEvent.find(user.latest_yes_event_id)
          if overlapping_events?(latest_yes_event, current_event)
            latest_yes_event.update_attributes(rsvp: 'no')
          end 
          user.update_latest_yes_event(current_event)
        end
        UserEvent.create(user: user, event: current_event, rsvp: rsvp)
      end 
    end 
  end 

  private 

  def sorted_events
    Event.order_by('start_time asc')
  end 

  def overlapping_events?(latest_yes_event, current_event)
    if latest_yes_event.all_day?
      (current_event.start_time >= latest_yes_event.start_time) && 
        (current_event.start_time.to_date <= latest_yes_event.end_time.to_date)
    else
      (current_event.start_time < latest_yes_event.end_time) && 
        (current_event.start_time >= latest_yes_event.start_time)
    end 
  end 
end 