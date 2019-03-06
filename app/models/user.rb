class User < ApplicationRecord
  include DataFormattable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :phone, presence: true

  has_many :users_events
  has_many :events, through: :users_events
end
