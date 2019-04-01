require 'rails_helper'

describe RsvpResolverService do 
  describe '#overlapping_events' do 
    context 'when all_day is fale' do 
      context 'when events are not overlapping' do 
        let(:service) { RsvpResolverService.new }
        let(:event1) { build(:event, start_time: Time.now - 10.hours, end_time: Time.now - 4.hours) }
        let(:event2) { build(:event, start_time: Time.now - 3.hours, end_time: Time.now - 1.hour) }
        it 'should return false' do
          expect(service.send(:overlapping_events?, event1, event2)).to be_falsey
        end 
      end 
    end 
  end 
end 