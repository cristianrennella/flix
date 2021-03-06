require 'spec_helper'

describe QueueItemsController do
	describe "GET index" do

		before {
			alice = Fabricate(:user)
			set_current_user(alice)
		}

		it "sets @queue_items to the queue items of the logged in user" do
			queue_item1 = Fabricate(:queue_item, user: current_user)
			queue_item2 = Fabricate(:queue_item, user: current_user)
			get :index
			expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])			
		end

		it "redirects to the sign in page for unauthenticated users" do
			clear_current_user
			get :index
			expect(response).to redirect_to login_path
		end

		it_behaves_like "require_sign_in" do
			let(:action) { get :index }
		end
	end

	describe "POST create" do
		it "redirects to the my queue page" do
			set_current_user
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(response).to redirect_to my_queue_path
		end

		it "creates a queue item" do
			set_current_user
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(QueueItem.count).to eq(1)
		end

		it "creates the queue item that is associated with the video" do
			set_current_user
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(QueueItem.first.video).to eq(video)
		end

		it "creates the queue item that is associated with the sign in user" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			video = Fabricate(:video)
			post :create, video_id: video.id
			expect(QueueItem.first.user).to eq(alice)
		end

		it "puts the video as the last one in the queue" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			monk = Fabricate(:video)
			Fabricate(:queue_item, video: monk, user: alice)
			south_park = Fabricate(:video)
			post :create, video_id: south_park.id
			south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
			expect(south_park_queue_item.position).to eq(2)
		end

		it "does not add the video to the queue if the video is already in the queue" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			monk = Fabricate(:video)
			Fabricate(:queue_item, video: monk, user: alice)
			post :create, video_id: monk.id
			expect(alice.queue_items.count).to eq(1)
		end

		it_behaves_like "require_sign_in" do
			let(:action) { get :create, video_id: 1 }
		end
	end

	describe "DELETE destroy" do
		it "deletes a item from the queue" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			queue_item = Fabricate(:queue_item, user: alice)
			delete :destroy, id: queue_item.id
			expect(QueueItem.count).to eq(0)
		end

		it "redirects to the my_queue view after removing the item" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			video1 = Fabricate(:video)
			queue_item1 = Fabricate(:queue_item, video: video1, user: alice)
			delete :destroy, id: queue_item1.id
			expect(response).to redirect_to my_queue_path
		end

		it "does not delete the item if the current user is not the owner" do
			alice = Fabricate(:user)
			bob = Fabricate(:user)
			session[:user_id] = alice.id
			queue_item1 = Fabricate(:queue_item, user: bob)
			delete :destroy, id: queue_item1.id
			expect(QueueItem.count).to eq(1)
		end

		it "normalizes teh remaining queue items after removing the item" do
			alice = Fabricate(:user)
			session[:user_id] = alice.id
			queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
			queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
			delete :destroy, id: queue_item1.id
			expect(QueueItem.first.position).to eq(1)
			# expect(queue_item2.reload.position).to eq(1)
		end

		it_behaves_like "require_sign_in" do
			let(:action) { delete :destroy, id: 1 }
		end
	end

	describe "POST update_queue" do
		context "with valid inputs" do
			let(:queue_item1) { Fabricate(:queue_item, user: current_user, video: video, position: 1) }
			let(:queue_item2) { Fabricate(:queue_item, user: current_user, video: video, position: 2) }
			let(:video) { Fabricate(:video) }

			before { set_current_user }

			it "redirects to the my queue page" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
				expect(response).to redirect_to my_queue_path
			end

			it "reorder queue items" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
				expect(current_user.queue_items).to eq([queue_item2, queue_item1])
			end

			it "normalizes the position numbers" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
				
				# expect(alice.queue_items.map(&:position)).to eq([1, 2])
				expect(queue_item1.reload.position).to eq(2) 
				# use reload because we change the attributes of the item in a local variable in the controller so here in the test they need to be updated from the database.
				expect(queue_item2.reload.position).to eq(1)
			end
		end

		context "with invalid inputs" do
			let(:alice) { Fabricate(:user) } 
			let(:queue_item1) { Fabricate(:queue_item, user: alice, video: video, position: 1) }
			let(:queue_item2) { Fabricate(:queue_item, user: alice, video: video, position: 2) }
			let(:video) { Fabricate(:video) }

			before do
				session[:user_id] = alice.id
			end

			it "redirects to the my queue page" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
				expect(response).to redirect_to my_queue_path
			end

			it "sets the flash error message" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
				expect(flash[:danger]).to be_present
			end

			it "does not change the queue items" do
				post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
				expect(queue_item1.reload.position).to eq(1)
			end
		end

		context "with unauthenticated inputs" do
			it_behaves_like "require_sign_in" do
				let(:action) { post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
			end
		end

		context "with queue items that do not belong to the current user" do
			it "does not change the queue items" do
				alice = Fabricate(:user)
				bob = Fabricate(:user)
				video = Fabricate(:video)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, user: bob, video: video, position: 1)
				queue_item2 = Fabricate(:queue_item, user: alice, video: video, position: 2)
				post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
				expect(queue_item1.reload.position).to eq(1)
			end
		end
	end

	# describe "POST add_video" do
	# 	it "adds video to the queue when it is empty with position 1" do
	# 		alice = Fabricate(:user)
	# 		session[:user_id] = alice.id
	# 		video = Fabricate(:video)
	# 		post :add_video, video_id: video.id
	# 		expect(assigns(:queue_items).count).to eq(1)
	# 		expect(assigns(:queue_items).first.position).to eq(1)
	# 	end

	# 	it "adds video to the queue when it has 1 item with position 2" do
	# 		alice = Fabricate(:user)
	# 		session[:user_id] = alice.id
	# 		video = Fabricate(:video)
	# 		post :add_video, video_id: video.id
	# 		video2 = Fabricate(:video)
	# 		post :add_video, video_id: video2.id
	# 		expect(assigns(:queue_items).count).to eq(2)
	# 		expect(assigns(:queue_items).second.position).to eq(2)
	# 	end

	# 	it "redirects to my_queue after adding the video" do
	# 		alice = Fabricate(:user)
	# 		session[:user_id] = alice.id
	# 		video = Fabricate(:video)
	# 		post :add_video, video_id: video.id
	# 		expect(response).to redirect_to my_queue_path
	# 	end

	# 	it "redirects to the sign in page for unauthenticated users" do
	# 		post :add_video
	# 		expect(response).to redirect_to login_path
	# 	end
	# end
end