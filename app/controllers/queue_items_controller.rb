class QueueItemsController < ApplicationController
	before_action :require_user
	
	def index
		@queue_items = current_user.queue_items
	end

	def create
		video = Video.find params[:video_id]
		queue_video(video)
		# AppMailer.notify_on_new_queued_video(current_user, video).deliver
		redirect_to my_queue_path
	end

	def destroy
		queue_item = QueueItem.find params[:id]
		queue_item.destroy if current_user.queue_items.include?(queue_item)
		current_user.normalize_queue_items_positions
		redirect_to my_queue_path
	end

	def update_queue
		begin
			update_queue_items
			current_user.normalize_queue_items_positions
		rescue ActiveRecord::RecordInvalid
			flash[:danger] = 'Invalid position numbers.'
		end

		redirect_to my_queue_path
	end

	private

	def queue_video(video)
		QueueItem.create(video: video, user: current_user, position: current_user.new_queue_item_position) unless current_user.queue_video? (video)
	end

	def update_queue_items
		ActiveRecord::Base.transaction do
			params[:queue_items].each do |queue_item_data|
				queue_item = QueueItem.find(queue_item_data["id"])
				queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if current_user.queue_items.include?(queue_item)
			end
		end
	end
end

	# def create
	# 	@video = Video.find params[:video_id]
	# 	QueueItem.create(video: @video, user: current_user, position: get_position)
	# 	@queue_items = current_user.queue_items
	# 	redirect_to my_queue_path
	# end

	# private

	# def get_position
	# 	queue_items = current_user.queue_items
	# 	if queue_items.empty?
	# 		return 1
	# 	else
	# 	 	return queue_items.last.position + 1
	# 	end
	# end