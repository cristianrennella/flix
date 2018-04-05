require 'spec_helper'

describe Category do
	it { should have_many(:videos) }
	it { should validate_presence_of(:name) }

	# it "saves itself" do
	# 	category = Category.new(name: "Terror")
	# 	category.save
	# 	expect(Category.first).to eq(category)
	# end

	# it "has many videos" do
	# 	comedies = Category.create(name: "comedies")
	# 	batman = Video.create(title: "Batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: comedies)
	# 	superman = Video.create(title: "Superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg", category: comedies)
	# 	expect(comedies.videos.size).to eq(2)
	# 	expect(comedies.videos).to include(batman, superman)
	# 	expect(comedies.videos).to eq([batman, superman])
	# end

	describe "#most_recent_videos" do
		it "returns empty array if there is no match" do
			actions = Category.create(name: "actions")
			expect(actions.most_recent_videos).to eq([])
		end

		it "returns 1 element array if there is one match" do
			actions = Category.create(name: "actions")
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: actions)
			expect(actions.most_recent_videos).to eq([batman])
		end

		it "returns 2 elements array ordered by date if there is a match" do
			actions = Category.create(name: "actions")
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: actions, created_at: 1.day.ago)
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg", category: actions)
			expect(actions.most_recent_videos).to eq([superman, batman])
		end

		it "returns a limit of 6 elements array where there are more than 6" do
			actions = Category.create(name: "actions")
			7.times { Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: actions) }
			expect(actions.most_recent_videos.count).to eq(6)
		end

		it "returns the more recent 6 videos" do
			actions = Category.create(name: "actions")
			7.times { Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: actions) }
			tonights_show = Video.create(title: "tonight", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: actions, created_at: 1.day.ago)
			expect(actions.most_recent_videos).not_to include(tonights_show)
		end
	end
end