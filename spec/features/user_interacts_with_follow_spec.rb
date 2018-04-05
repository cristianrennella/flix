require 'spec_helper'

feature 'User following' do
	scenario "user follows and unfollows someone" do
		alice = Fabricate(:user)
		bob = Fabricate(:user)
		comedies = Fabricate(:category)
		monk = Fabricate(:video, title: "Monk", category: comedies)
		review = Fabricate(:review, video: monk, user: bob)

		sign_in(alice)

		visit home_path

		click_on_video(monk)
		click_link bob.username

		expect_follow_button_to_be_seen
		click_link "Follow"

		expect_leader_to_be_in_list(bob)

		click_on_unfollow(bob)

		expect_leader_not_to_be_in_list(bob)
	end

	def expect_leader_to_be_in_list(user)
		page.should have_content user.username
	end

	def expect_leader_not_to_be_in_list(user)
		page.should_not have_content user.username
	end

	def expect_follow_button_to_be_seen
		page.should have_content('Follow')
	end

	def click_on_follow(user)
		find("a[href='/relationships?leader_id=#{user.id}']").click
	end

	def click_on_unfollow(user)
		# find("a[href='/relationships/#{user.leading_relationships.first.id}']").click
		find("a[data-method='delete']").click
	end

	def click_on_video(video)
		find("a[href='/videos/#{video.id}']").click
	end

	def click_on_a_review_owner(user)
		find("a[href='/users/#{user.id}']").click
	end
end