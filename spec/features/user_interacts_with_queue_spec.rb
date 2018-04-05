require 'spec_helper'

feature 'User interacts with the queue' do
	scenario "user adds and reorders videos in the queue" do
		comedies = Fabricate(:category)
		monk = Fabricate(:video, title: "Monk", category: comedies)
		south_park = Fabricate(:video, title: "South Park", category: comedies)
		futurama = Fabricate(:video, title: "Futurama", category: comedies)

		sign_in

		add_video_to_queue(monk)
		expect_video_to_be_in_queue(monk)

		visit video_path(monk)
		expect_link_not_to_be_seen("+ My Queue")

		# visit home_path
		# find("a[href='/videos/#{south_park.id}']").click
		# click_link "+ My Queue"

		# visit home_path
		# find("a[href='/videos/#{futurama.id}']").click
		# click_link "+ My Queue"

		add_video_to_queue(south_park)
		add_video_to_queue(futurama)

		# within(:xpath, "//tr[contains(.,'#{monk.title}')]") do
		# 	fill_in "queue_items[][position]", with: 3
		# end

		# within(:xpath, "//tr[contains(.,'#{futurama.title}')]") do
		# 	fill_in "queue_items[][position]", with: 2
		# end

		# within(:xpath, "//tr[contains(.,'#{south_park.title}')]") do
		# 	fill_in "queue_items[][position]", with: 1
		# end

		set_video_position(south_park, 1)
		set_video_position(futurama, 2)
		set_video_position(monk, 3)

		# find("input[data-video-id='#{monk.id}']").set(3)
		# find("input[data-video-id='#{futurama.id}']").set(2)
		# find("input[data-video-id='#{south_park.id}']").set(1)
		
		# fill_in "video_#{monk.id}", with: 3
		# fill_in "video_#{futurama.id}", with: 2
		# fill_in "video_#{south_park.id}", with: 1 

		click_button "Update Instant Queue"

		# expect(find("#video_#{south_park.id}").value).to eq("1")
		# expect(find("#video_#{futurama.id}").value).to eq("2")
		# expect(find("#video_#{monk.id}").value).to eq("3")

		# expect(find("input[data-video-id='#{monk.id}']").value).to eq("3")
		# expect(find("input[data-video-id='#{futurama.id}']").value).to eq("2")
		# expect(find("input[data-video-id='#{south_park.id}']").value).to eq("1")

		expect_video_position(south_park, "1")
		expect_video_position(futurama, "2")
		expect_video_position(monk, "3")

		# expect(find(:xpath, "//tr[contains(.,'#{south_park.title}')]//input[@type='text']").value).to eq("1")
		# expect(find(:xpath, "//tr[contains(.,'#{futurama.title}')]//input[@type='text']").value).to eq("2")
		# expect(find(:xpath, "//tr[contains(.,'#{monk.title}')]//input[@type='text']").value).to eq("3")
	end

	def expect_video_to_be_in_queue(video)
		page.should have_content(video.title)
	end

	def expect_link_not_to_be_seen(link)
		page.should_not have_content link
	end

	def add_video_to_queue(video)
		visit home_path
		find("a[href='/videos/#{video.id}']").click
		click_link "+ My Queue"
	end

	def set_video_position(video, position)
		within(:xpath, "//tr[contains(.,'#{video.title}')]") do
			fill_in "queue_items[][position]", with: position
		end
	end

	def expect_video_position(video, position)
		expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position)
	end
end

# feature 'User interacts with the queue' do
# 	scenario "add a video to the queue" do
# 		alice = Fabricate(:user)
# 		category = Category.create(name: "actions")
# 		video = Fabricate(:video, category: category)

# 		visit login_path
# 		fill_in "email", with: alice.email
# 		fill_in "password", with: alice.password
# 		click_button "Log In"

# 		find(:xpath, "//a[@href='/videos/#{video.id}']").click
		
# 		click_link('+ My Queue')

# 		page.should have_content video.title

# 		click_link(video.title)

# 		page.should have_content video.title
# 		page.should have_no_content('+ My Queue')
# 	end

# 	scenario "add 3 videos to the queue, change order and check for correct reorder" do
# 		alice = Fabricate(:user)
# 		category = Category.create(name: "actions")
# 		video1 = Fabricate(:video, category: category)
# 		video2 = Fabricate(:video, category: category)
# 		video3 = Fabricate(:video, category: category)

# 		visit login_path
# 		fill_in "email", with: alice.email
# 		fill_in "password", with: alice.password
# 		click_button "Log In"

# 		find(:xpath, "//a[@href='/videos/#{video1.id}']").click
# 		click_link('+ My Queue')

# 		visit home_path
# 		find(:xpath, "//a[@href='/videos/#{video2.id}']").click
# 		click_link('+ My Queue')

# 		visit home_path
# 		find(:xpath, "//a[@href='/videos/#{video3.id}']").click
# 		click_link('+ My Queue')

# 		page.should have_content video1.title
# 		page.should have_content video2.title
# 		page.should have_content video3.title

# 		find(:xpath, "//input[@value='1']").set '666'
# 		find(:xpath, "//input[@value='2']").set '555'
# 		find(:xpath, "//input[@value='3']").set '444'

# 		click_button("Update Instant Queue")

# 		page.should have_no_content('666')
# 		page.should have_no_content('555')
# 		page.should have_no_content('444')

# 		expect(User.first.queue_items.first.video_id).to eq(video3.id)
# 	end
# end