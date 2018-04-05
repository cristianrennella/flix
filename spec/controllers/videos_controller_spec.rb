require 'spec_helper'

describe VideosController do
	describe "GET show" do
		context "with authenticated users" do
			before do
				session[:user_id] = Fabricate(:user).id
			end

			it "sets @video" do
				video = Fabricate(:video)
				get :show, id: video.id
				expect(assigns(:video)).to eq(video)
			end

			it "sets @reviews" do
				video = Fabricate(:video)
				review1 = Fabricate(:review, video: video)
				review2 = Fabricate(:review, video: video)
				get :show, id: video.id
				expect(assigns(:reviews)).to match_array([review1, review2])
			end

			it "renders the show template" do
				video = Fabricate(:video)
				get :show, id: video.id
				expect(response).to render_template :show
			end
		end

		context "with unauthenticated users" do
			it "redirects the user to the log in page" do
				video = Fabricate(:video)
				get :show, id: video.id
				expect(response).to redirect_to login_path 
			end
		end
	end

	describe "GET search" do
		it "sets @results for authenticated users" do
			session[:user_id] = Fabricate(:user).id
			futurama = Fabricate(:video, title: "Futurama")
			get :search, search_term: 'rama'
			expect(assigns(:videos)).to eq([futurama])
		end

		it "redirects to sign in for the unauthenticated" do
			futurama = Fabricate(:video, title: "Futurama")
			get :search, search_term: 'rama'
			expect(response).to redirect_to login_path
		end
	end
end


# describe VideosController do
# 	describe "GET index" do
# 		it "sets the @videos variable" do
# 			simpsons = Video.create(title: "Simpsons", description: "bla bla")
# 			batman = Video.create(title: "Batman", description: "bla bla")

# 			get :index
# 			assigns(:videos).should == [simpsons, batman]
# 		end
# 		it "renders the index template" do
# 			get :index
# 			response.should render_template :index
# 		end
# 	end

# 	describe "GET new" do
# 		it "sets the @video variable" do
# 			get :new
# 			assigns(:video).should be_new_record
# 			assigns(:video).should be_instance_of(Video)
# 		end
# 		it "renders the new template" do
# 			get :new
# 			response.should render_template :new
# 		end
# 	end

# 	describe "POST create" do
# 		it "creates the video record when the input is valid" do
# 			post :create, video: {title: "Simpsons", description: "bla bla"}
# 			Todo.first.name.should == "Simpsons"
# 			Todo.first.description.should == "bla bla"
# 		end
# 		it "redirects the to the root path when the input is valid template" do
# 			post :create, video: {title: "Simpsons", description: "bla bla"}
# 			response.should redirect_to root_path
# 		end
# 		it "does not create a video when the input is invalid template" do
# 			post :create, video: {description: "bla bla"}
# 			Video.count.should == 0;
# 		end
# 		it "renders the new template when the input is invalid template" do
# 			post :create, video: {description: "bla bla"}
# 			response.should render_template :new
# 		end
# 	end

	# describe "#display_text" do
	# 	let(:video) { Fabricate.build(:video) }
	# 	# let(:video) { Fabricate(:video) } # Saves to the db
	# 	let(:subject) { video.display_text }

	# 	it "display the name when there's no tags" do
	# 		subject.should == "Simpsons"
	# 	end

	# 	it "display the only tag with word tag when there is one tag" do
	# 		video.categories.create(name: "drama")
	# 		subject.should == "Simpsons (category: drama)"
	# 	end

	# 	# it "display name with multiple tags" do
	# 	# 	video.categories.create(name: "drama") 
	# 	# 	video.categories.create(name: "terror")
	# 	# 	subject.should == "Simpsons (categories: drama, terror)"
	# 	# end
	# 	context "multiple tags" do
	# 		before do 
	# 			video.categories.create(name: "drama")
	# 			video.categories.create(name: "terror")
	# 		end
	# 		it { should == "Simpsons (categories: drama, error)" }
	# 	end

	# 	it "display up to four tags" do
	# 		video.categories.create(name: "drama") 
	# 		video.categories.create(name: "terror")
	# 		video.categories.create(name: "comedy") 
	# 		video.categories.create(name: "action")
	# 		video.categories.create(name: "suspend") 
	# 		video.categories.create(name: "urgent")
	# 		subject.should == "Simpsons (categories: drama, terror, comedy, action, more...)"
	# 	end
	# end
# end