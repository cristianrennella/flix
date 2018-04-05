require 'spec_helper'

describe ReviewsController do
	describe "POST create" do
		let(:video) { Fabricate(:video) }
		context "with authenticated users" do
			let(:current_user) { Fabricate(:user) }
			before { session[:user_id] = current_user }
			context "with valid inputs" do
				before do
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
				end 

				it "creates the review" do
					expect(Review.count).to eq(1)
				end

				it "redirects to the show page" do
					expect(response).to redirect_to video
				end

				it "creates the review associated with the video" do
					expect(Review.first.video).to eq(video)
				end

				it "creates the review associated with the signed user" do
					expect(Review.first.user).to eq(current_user)
				end
			end

			context "with invalid inputs" do
				it "does not create a review" do
					post :create, video_id: video.id, review: {rating: 5}
					expect(Review.count).to eq(0)
				end

				it "renders the video/show page" do
					post :create, video_id: video.id, review: {rating: 5}
					expect(response).to render_template "videos/show"
				end

				it "sets video" do
					post :create, video_id: video.id, review: {rating: 5}
					expect(assigns(:video)).to eq(video)
				end

				it "sets reviews" do
					review = Fabricate(:review, video: video)
					post :create, video_id: video.id, review: {rating: 5}
					expect(assigns(:reviews)).to match_array([review])
				end
			end
		end

		context "with unauthenticated users" do
			it "redirects the user to the log in page" do
				post :create, review: Fabricate.attributes_for(:review), video_id: video.id
				expect(response).to redirect_to login_path 
			end
		end
	end
end