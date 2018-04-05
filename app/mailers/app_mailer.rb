class AppMailer < ActionMailer::Base
	def welcome_user(user)
		@user = user
		mail from: 'info@myflixapp.com', to: user.email, subject: "Welcome to your new home!."
	end

	def notify_on_new_queued_video(user, video)
		@video = video
		mail from: 'info@myflixapp.com', to: user.email, subject: "You have a added a new video to your queue."
	end
end