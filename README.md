# Event Manager

## Assumptions

- Given : a user having multiple events at the same time can not have rsvp as `yes` for more than one overlapping events. In such case consider the rsvp of last overlapping event to be `yes`
- - Inference : In case of overlapping events, `last` overlapping is the one that starts last

- Given : End datetime should be ignored if event is an all day event
- - Inference : For an all day event, only consider the `end_date` but ignore the `end_time` on that same day

- Event
    - user#rsvp column can fit in text
    - user#rsvp input is valid, meaning same username will not be used twice. In case it is repeated, the last entry will be considered
- CSV processing within 1 hour as Cache expires at that time

## Workflow
```ruby
rails db:create
rails db:migrate
rails db:seed
```
1. Seed file seeds the users and events table
2. `RsvpResolverService` is responsible for storing the rsvps for given event

## Optimizations 

1. Processing events in increasing order of `starttime` saves a lot of queries as we will only compare the current event in computation with the last one that was processed for user in consideration
2. Used redis for storing the last event that got processed to save on hitting the database
3. Used eager loading wherever necessary
4. Added necessary indexes

