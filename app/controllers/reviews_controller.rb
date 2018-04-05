class ReviewsController < ApplicationController
	before_action :require_user

	def create
		@video = Video.find params[:video_id]
		review = @video.reviews.new(params.require(:review).permit(:description, :rating))
		review.user = current_user

		if review.save
			flash[:notice] = "Your review was added"
			redirect_to @video
		else
			@reviews = @video.reviews.reload # Rails will load from db. Because in memory we have a invalid review from line 6.
			render 'videos/show'
		end
	end
end