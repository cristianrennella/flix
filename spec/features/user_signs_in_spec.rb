require 'spec_helper'

feature 'user signs in' do
	background do 
		# User.create(username: "cristian", email: "cristian@gmail.com", password: "password")
	end

	scenario "with valid email and password" do
		alice = Fabricate(:user)
		sign_in(alice)
		# visit login_path
		# fill_in "email", with: "cristian@gmail.com"
		# fill_in "email", with: alice.email
		# fill_in "password", with: "password"
		# fill_in "password", with: alice.password
		# click_button "Log In"
		# page.should have_content "Welcome, cristian"
		page.should have_content alice.username
	end
end