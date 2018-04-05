class Category < ActiveRecord::Base
	has_many :videos, -> { order("title") }

	validates_presence_of :name

	def most_recent_videos
		# videos.reorder("created_at DESC").limit(6)
		videos.reorder("created_at DESC").first(6)
	end
end