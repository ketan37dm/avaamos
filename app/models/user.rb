class User < ApplicationRecord
  include DataFormattable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :phone, presence: true

  validate :phone_number_with_phony

  has_many :users_events
  has_many :events, through: :users_events

  private 

  def phone_number_with_phony
  	if phone
  		base_number = phone.downcase.gsub(/[^0-9x]/, '').split('x')[0]
  		errors.add(:phone, 'Invalid phone') unless Phony.plausible?(base_number) || Phony.plausible?("+1#{base_number}")
  	end 
  end 
end
