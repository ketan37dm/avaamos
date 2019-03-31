class UserEvent < ApplicationRecord
	self.table_name = 'users_events'
	belongs_to :user
	belongs_to :event
end 