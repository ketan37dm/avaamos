class User < ApplicationRecord
  include DataFormattable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :phone, presence: true

  validate :phone_number_with_phony

  has_many :users_events
  has_many :events, through: :users_events

  def latest_yes_event_id
    Rails.cache.fetch("user:#{id}:latest_yes_event_id")
  end 

  def update_latest_yes_event_id(id)
    Rails.cache.write("user:#{id}:latest_yes_event_id", id, expires_in: 1.hour)
  end 

  private 

  def phone_number_with_phony
  	if phone
  		base_number = phone.downcase.gsub(/[^0-9x]/, '').split('x')[0]
  		errors.add(:phone, 'Invalid phone') unless Phony.plausible?(base_number) || Phony.plausible?("+1#{base_number}")
  	end 
  end 
end
