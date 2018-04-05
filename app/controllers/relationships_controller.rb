class RelationshipsController < ApplicationController
	before_action :require_user

	def index
		@relationships = current_user.following_relationships
	end

	def create
		# relationship = @current_user.following_relationships.new(leader_id: params[:leader_id])

		# if relationship.save
		# 	flash[:notice] = "Your relationship was added"
		# 	redirect_to people_path
		# else
		# 	flash[:notice] = "Your relationship could not be created"
		# 	render :back
		# end

		leader = User.find params[:leader_id]
		Relationship.create(leader_id: params[:leader_id], follower: current_user) if current_user.can_follow?(leader)
		redirect_to people_path
	end

	def destroy
		relationship = Relationship.find(params[:id])
		relationship.destroy if relationship.follower == current_user
		redirect_to people_path
	end
end