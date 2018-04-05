class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :video
	
	validates_presence_of :description, :rating
end