class UsersController < ApplicationController
	before_action :require_user, only: [:show]
	
	def show
		@user = User.find params[:id]
	end

	def new
		@user = User.new
		render :register
	end

	def create
		@user = User.new(user_params)

		if @user.save
			flash[:notice] = "You have registered!"
			AppMailer.welcome_user(@user).deliver
			redirect_to home_path
		else
			render :register
		end
	end

	def following
		@user = current_user
	end

	private

	def user_params
		params.require(:user).permit(:username, :email, :password)
	end
end