class Video < ActiveRecord::Base
	belongs_to :category

	has_many :reviews, -> { order("created_at DESC")}

	validates_presence_of :title, :description

	def self.search_by_title(search_term)
		return [] if search_term.blank?
		where("lower(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
	end

	def reviews_average
		return '-' if reviews.count == 0
		(reviews.inject(0){|sum, review| sum + review.rating } / reviews.count).round(1)
	end
end