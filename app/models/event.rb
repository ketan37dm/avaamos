class Event < ApplicationRecord
  include DataFormattable

  validates :title, presence: true
  validates :start_time, presence: true
  validates :all_day, presence: true

  has_many :users_events
  has_many :users, through: :users_events
end
