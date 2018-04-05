class SessionsController < ApplicationController
	def new
		redirect_to home_path if logged_in?
	end

	def create
		user = User.find_by email: params[:email]
		
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:success] = "Welcome!."
			redirect_to home_path
		else
			flash[:danger] = "There is something wrong."
			redirect_to login_path
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:success] = "You've logged out."
		redirect_to login_path
	end
end