require 'spec_helper'

describe UsersController do
	describe "GET new" do
		it "sets @user" do
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end

		it "renders the register template" do
			user = User.new
			get :new
			expect(response).to render_template :register
		end
	end

	describe "GET show" do
		it_behaves_like "require_sign_in" do
			let(:action) {get :show, id: 3}
		end

		it "sets @user" do
			alice = Fabricate(:user)
			set_current_user(alice)
			get :show, id: alice.id
			expect(assigns(:user)).to eq(alice)
		end
	end

	describe "POST create" do
		context "with valid input" do
			before { post :create, user: Fabricate.attributes_for(:user) }
			it "creates the user" do
				expect(User.count).to eq(1)
			end

			it "redirects to the home page" do
				expect(response).to redirect_to home_path
			end
		end

		context "with invalid input" do
			before do
				post :create, user: {username: "Cristian", password: "password"}
			end
			
			it "creates the user" do
				expect(User.count).to eq(0)
			end

			it "render to the new template" do
				expect(response).to render_template :register
			end

			it "sets @user" do
				expect(assigns(:user)).to be_instance_of(User)
			end
		end
	end

	# describe "GET following" do
	# 	it_behaves_like "require_sign_in" do
	# 		let(:action) {get :show, id: 3}
	# 	end

	# 	it "sets @user" do
	# 		alice = Fabricate(:user)
	# 		set_current_user(alice)
	# 		get :following, id: alice.id
	# 		expect(assigns(:user)).to eq(alice)
	# 	end

	# 	it "renders the following template" do
	# 		alice = Fabricate(:user)
	# 		set_current_user(alice)
	# 		get :following, id: alice.id
	# 		expect(response).to render_template :following
	# 	end
	# end
end