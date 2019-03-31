class User < ApplicationRecord
  include DataFormattable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :phone, presence: true

  validate :phone_number_with_phony

  has_many :registrations
  has_many :events, through: :registrations
  has_many :yes_events, 
        -> { where "registrations.rsvp = 'yes'" },
        through: :registrations,
        source: :event
  has_many :no_events, 
        -> { where "registrations.rsvp = 'no'" },
        through: :registrations,
        source: :event
  has_many :maybe_events, 
        -> { where "registrations.rsvp = 'maybe'" },
        through: :registrations,
        source: :event


  def latest_reg_id
    Rails.cache.read("user:#{self.id}:latest_reg_id")
  end 

  def update_latest_reg_id(reg_id)
    Rails.cache.write("user:#{self.id}:latest_reg_id", reg_id, expires_in: 1.hour)
  end 

  private 

  def phone_number_with_phony
  	if phone
  		base_number = phone.downcase.gsub(/[^0-9x]/, '').split('x')[0]
  		errors.add(:phone, 'Invalid phone') unless Phony.plausible?(base_number) || Phony.plausible?("+1#{base_number}")
  	end 
  end 
end
