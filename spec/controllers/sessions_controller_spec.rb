require 'spec_helper'

describe SessionsController do
	describe "GET new" do
		it "renders new template for unauthenticated users" do
			get :new
			expect(response).to render_template :new
		end

		context "with authenticated users" do
			before do
				session[:user_id] = Fabricate(:user).id
			end

			it "redirect to home for authentichated users" do
				get :new
				expect(response).to redirect_to home_path
			end
		end
	end

	describe "POST create" do
		context "with valid credentials" do
			let(:user) { Fabricate(:user) }
			
			before do
				post :create, email: user.email, password: user.password
			end

			it "puts the asigned in user in the session" do
				expect(session[:user_id]).to eq(user.id)
			end

			it "redirects to the home page" do
				expect(response).to redirect_to home_path
			end

			it "sets the notice" do
				expect(flash[:success]).not_to be_blank
			end
		end

		context "with invalid credentials" do
			before do
				user = Fabricate(:user)
				post :create, email: user.email, password: user.password + '12345'
			end

			it "does not asigned in user in the session" do
				expect(session[:user_id]).to be_nil
			end

			it "redirects to the sign in page" do
				expect(response).to redirect_to login_path
			end

			it "sets the danger" do
				expect(flash[:danger]).not_to be_blank
			end
		end
	end

	describe "GET destroy" do
		before do
			session[:user_id] = Fabricate(:user).id
			get :destroy
		end
		it "clears the session for the user" do
			expect(session[:user_id]).to be_nil
		end

		it "redirects to the login path" do
			expect(response).to redirect_to login_path
		end

		it "writes the flash message" do
			expect(flash[:success]).not_to be_blank
		end

	end
end