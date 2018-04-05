require 'spec_helper'

describe RelationshipsController do
	describe "GET index" do
		it "set @relationships to the current user's following relationships" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			get :index
			expect(assigns(:relationships)).to eq([relationship])
		end

		it_behaves_like "require_sign_in" do
			let(:action) { get :index }
		end
	end

	describe "POST create" do
		it_behaves_like "require_sign_in" do
			let(:action) { delete :destroy, id: 4 }
		end

		it "redirects to the people page" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			post :create, leader_id: bob.id
			expect(response).to redirect_to people_path
		end

		it "create a relationship where current user follows other user" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			post :create, leader_id: bob.id
			# expect(Relationship.count).to eq(1)
			expect(alice.following_relationships.first.leader).to eq(bob)
		end

		it "does not create a relationship if the current user already follows that leader" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			Fabricate(:relationship, leader: bob, follower: alice)
			post :create, leader_id: bob.id
			expect(Relationship.count).to eq(1)
		end

		it "does not allows to follow themselves" do
			alice = Fabricate(:user)
			set_current_user(alice)
			post :create, leader_id: alice.id
			expect(Relationship.count).to eq(0)
		end
	end

	describe "DELETE destroy" do
		it_behaves_like "require_sign_in" do
			let(:action) { delete :destroy, id: 4 }
		end

		it "redirects to the people page" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			delete :destroy, id: relationship
			expect(response).to redirect_to people_path
		end

		it "deletes the relationship if the current user is the follower" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob)
			delete :destroy, id: relationship
			expect(Relationship.count).to eq(0)
		end

		it "does not delete the relationship if the current user is not the follower" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			charlie = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: charlie, leader: bob)
			delete :destroy, id: relationship
			expect(Relationship.count).to eq(1)
		end
	end
end