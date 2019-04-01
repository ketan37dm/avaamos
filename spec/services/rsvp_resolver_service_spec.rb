require 'rails_helper'

describe RsvpResolverService do 
  let(:service) { RsvpResolverService.new }
  
  describe '#overlapping_events' do 
    context 'when all_day is false' do 
      context 'when events are not overlapping' do 
        let(:event1) { build(:event, start_time: Time.now - 10.hours, end_time: Time.now - 4.hours) }
        let(:event2) { build(:event, start_time: Time.now - 3.hours, end_time: Time.now - 1.hour) }
        it 'should return false' do
          expect(service.send(:overlapping_events?, event1, event2)).to be_falsey
        end 
      end 

      context 'when events are overlapping' do 
        let(:event1) { build(:event, start_time: Time.now - 10.hours, end_time: Time.now - 4.hours) }
        let(:event2) { build(:event, start_time: Time.now - 8.hours, end_time: Time.now - 1.hour) }        
        it 'should return true' do 
          expect(service.send(:overlapping_events?, event1, event2)).to be_truthy
        end 
      end 
    end 

    context 'when all_day is true' do 
      context 'when events are overlapping' do 
        let(:event1) { build(:event, start_time: Time.now - 5.days, end_time: Time.now - 1.day, all_day: true) }
        let(:event2) { build(:event, start_time: Time.now - 1.day, end_time: Time.now - 1.hour, all_day: true) }        
        it 'should return true' do 
          expect(service.send(:overlapping_events?, event1, event2)).to be_truthy
        end 
      end 

      context 'when events are not overlapping' do 
        let(:event1) { build(:event, start_time: Time.now - 5.days, end_time: Time.now - 2.days, all_day: true) }
        let(:event2) { build(:event, start_time: Time.now - 1.day, end_time: Time.now - 1.hour, all_day: true) }  
        it 'should return false' do
          expect(service.send(:overlapping_events?, event1, event2)).to be_falsey
        end 
      end       
    end 
  end 

  describe '#execute' do 
    let!(:user) { create(:user) }
    context 'when rsvp is yes' do 
      context 'when events are non overlapping' do 
        let!(:event1) { create(:event, start_time: Time.now - 5.days, end_time: Time.now - 2.days, rsvps: "#{user.username}#yes") }
        let!(:event2) { create(:event, start_time: Time.now - 1.day, end_time: Time.now - 1.hour, rsvps: "#{user.username}#yes") }

        it 'user should be registered for both the events' do 
          service.execute
          expect(user.yes_events.count).to eq(2)
        end 
      end 

      context 'when events are overlapping' do 
        let!(:event1) { create(:event, start_time: Time.now - 5.days, end_time: Time.now - 2.days, rsvps: "#{user.username}#yes") }
        let!(:event2) { create(:event, start_time: Time.now - 3.days, end_time: Time.now - 1.hour, rsvps: "#{user.username}#yes") }        
        it 'user should be registered to the last overlapping event' do 
          service.execute
          expect(user.yes_events.count).to eq(1)
          expect(user.yes_events.first).to eq(event2)
        end 
      end 
    end 
  end 
end 