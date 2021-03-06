class User < ActiveRecord::Base
	has_secure_password validations: false

	has_many :reviews, -> { order(:created_at) }

	validates_presence_of :username, :email, :password
	validates_uniqueness_of :email

	has_many :queue_items, -> { order(:position) }

	has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
	has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'

	# has_many :followships
	# has_many :followers, :through => :followships
	# has_many :inverse_followships, class_name: 'Followship', foreign_key: 'follower_id'
	# has_many :following, :through => :inverse_followships, source: :user

	def normalize_queue_items_positions
		queue_items.each_with_index do |queue_item, index|
			queue_item.update_attributes(position: index+1)
		end
	end

	def new_queue_item_position
		queue_items.count + 1
	end

	def queue_video?(video)
		queue_items.map(&:video).include?(video)
	end

	def follows?(another_user)
		following_relationships.map(&:leader).include?(another_user)
	end

	def can_follow?(another_user)
		!(follows?(another_user) || self == another_user)
	end
end