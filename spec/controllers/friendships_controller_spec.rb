require 'spec_helper'

describe FriendshipsController do
  let!(:user1) {Fabricate(:user)}
  let!(:user2) {Fabricate(:user)}
  let!(:user3) {Fabricate(:user)}
  let!(:friendship1) {Fabricate(:friendship, leader: user2, follower: user1)}
  let!(:friendship2) {Fabricate(:friendship, leader: user2, follower: user3)}

  context "signed in" do
    before { sign_in(user1) }

    describe "GET index" do
      it "renders friendship index page" do
        get :index, user_id: current_user.id
        expect(response).to render_template(:index)
      end
    end

    describe "DELETE destroy" do
      it "deletes specified relationship if current user is follower" do
        delete :destroy, user_id: current_user.id, id: friendship1.id
        expect(current_user.reload.following_relationships.count).to eq(0)
      end

      it "redirects to index page" do
        delete :destroy, user_id: current_user.id, id: friendship1.id
        expect(response).to redirect_to user_friendships_path(current_user) 
      end

      it "does not delete relationship if current user is not the follower" do
        delete :destroy, user_id: user3.id, id: friendship2.id
        expect(user3.reload.following_relationships.count).to eq(1)
      end
    end

    describe "POST create" do
      it "creates a friendship between user and leader" do
        post :create, user_id: current_user.id, leader_id: user3.id
        expect(current_user.following_relationships.last.leader).to eq(user3)
      end

      it "does not allow user to create friendship with him/herself" do
        post :create, user_id: current_user.id, leader_id: current_user.id
        expect(current_user.following_relationships.count).to eq(1)
      end

      it "does not allow user to create friendship where it already exists" do
        post :create, user_id: current_user.id, leader_id: user2.id
        expect(current_user.following_relationships.count).to eq(1)
      end     
    end
  end

  context "not signed_in" do
    describe "GET index" do
      it_behaves_like "requires sign-in" do
        let(:action) {get :index,user_id: user1.id}
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "requires sign-in" do
        let(:action) {delete :destroy, user_id: user1.id, id: friendship1.id
}
      end
    end

  end

end