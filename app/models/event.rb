class Event < ApplicationRecord
  include DataFormattable

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :all_day, inclusion: { in: [true, false] }

  validate :event_timings

  has_many :users_events
  has_many :users, through: :users_events

  private 

  def event_timings
  	errors.add(:base, 'Start time should be less than end time') if start_time > end_time
  end 
end
