require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should have_many(:reviews).order("created_at DESC")}

	# it "saves itself" do
	# 	video = Video.new(title: "Batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category_id: 1)
	# 	video.save
	# 	expect(Video.first).to eq(video)
	# 	# Video.first.title.should == "Batman"
	# end

	# it "belongs to a category" do
	# 	dramas = Category.create(name: "dramas")
	# 	batman = Video.create(title: "Batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", category: dramas)
	# 	expect(batman.category).to eq(dramas)
	# end

	# it "does not save a video without a description" do
	# 	batman = Video.create(title: "Batman")
	# 	expect(Video.count).to eq(0)
	# end

	# it "does not save a video without a title" do
	# 	batman = Video.create(description: "bla bla bla...")
	# 	expect(Video.count).to eq(0)
	# end

	describe "search_by_title" do
		it "returns empty array if there is no match" do
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg")
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg")
			expect(Video.search_by_title('asdfgjkl')).to eq([])
		end

		it "returns an array of one video for an exact match" do
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg")
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg")
			expect(Video.search_by_title('batman')).to eq([batman])
		end

		it "returns an array of one video for an partial match" do
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg")
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg")
			expect(Video.search_by_title('tman')).to eq([batman])
		end

		it "returns an array of all matches ordered by created_at" do
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", created_at: 1.day.ago)
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg")
			expect(Video.search_by_title('man')).to eq([superman, batman])
		end

		it "returns an empty array for a search of an empty string" do
			batman = Video.create(title: "batman", description: "bla bla bla...", small_cover_url: "batman.jpg", large_cover_url: "batman.jpg", created_at: 1.day.ago)
			superman = Video.create(title: "superman", description: "bla bla bla...", small_cover_url: "superman.jpg", large_cover_url: "superman.jpg")
			expect(Video.search_by_title('')).to eq([])
		end
	end
end