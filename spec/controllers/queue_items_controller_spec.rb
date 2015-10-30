require 'spec_helper'
describe QueueItemsController do
  let(:user1) {Fabricate(:user)}
  let(:user2) {Fabricate(:user)}
  
  let(:queue_item1) {Fabricate(:queue_item, user: current_user, position: 1, video: video1, id: 1)}
  let(:queue_item2) {Fabricate(:queue_item, user: current_user, position: 2, id: 2)}
  let(:queue_item3) {Fabricate(:queue_item, user: current_user, position: 3, id: 3)}
  let!(:queue_item4) {Fabricate(:queue_item, user: user2, position: 1, id: 4)}
  let!(:queue_item5) {Fabricate(:queue_item, user: user1, position: 1, id: 5)}

  let!(:review1) {Fabricate(:review, rating: 1, user: current_user, video: video1)}
  let(:video1) {Fabricate(:video)}
  let(:video2) {Fabricate(:video)}
  let(:video3) {Fabricate(:video)}

  context "logged in user" do 
    before { sign_in }

    describe "GET index" do
      before do
        get :index, user_id: current_user.id
      end

      it "assigns all of current users's queue items to queue" do
        expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
      end
      
      it "renders queue index page" do
        expect(response).to render_template :index
      end
    end

    describe "POST create" do
      context "empty queue" do
        before do
          post :create, user_id: current_user.id, video_id: video1.id 
        end

        it "creates and save queue_item" do
          expect(current_user.queue_items.reload.count).to eq(1)
        end

        it "creates queue item with position 1 if first queue item" do
          expect(current_user.queue_items.first.position).to eq(1)
        end
      end

      context "non empty queue" do
        before do 
          Fabricate(:queue_item, user: current_user, position: current_user.queue_items.size + 1, video: video1)
          Fabricate(:queue_item, user: current_user, position: current_user.queue_items.size + 1, video: video2) 
          current_user.reload
        end

        it "creates queue item with position 1 more than last queue item" do
          post :create, user_id: current_user.id, video_id: video3.id
          expect(current_user.queue_items.last.position).to eq(3)
        end

        context "video already in queue" do
          before do
            post :create, user_id: current_user.id, video_id: video1.id
          end

          it "does not save queue_item if it already exists" do
            expect(current_user.queue_items.size).to eq(2)
          end

          it "displays flash error message" do
            expect(flash['danger']).to be_present
          end
        end  
      end

      it "redirects to queue index" do
        post :create, user_id: current_user.id, video_id: video3.id
        expect(response).to redirect_to user_queue_items_path(current_user)
      end

    end 

    describe "DELETE destroy" do
      it "deletes queue item" do
        current_user.queue_items << queue_item2
        delete :destroy, user_id: current_user, id: queue_item2.id
        expect(current_user.queue_items.size).to eq(0)
      end

      it "redirects to queue index" do
        delete :destroy, user_id: current_user, id: queue_item2.id
        expect(response).to redirect_to user_queue_items_path(current_user)
      end

      it "reorders position numbers" do
        queue_item1
        queue_item2
        queue_item3

        delete :destroy, user_id: current_user, id: queue_item2.id
        expect(current_user.queue_items.reload).to match_array([queue_item1, queue_item3])
      end
    end

    describe "POST update_queue" do
      before do
        queue_item1
        queue_item2
        queue_item3
      end

      context "valid input" do
        context "update to position" do
          it "rearranges queue_items" do
            post :update_queue,user_id: current_user, queue_items: [{id: 1, position: 3}, {id: 2, position: 1}, {id: 3, position: 2}]
            expect(current_user.queue_items).to match_array([queue_item2, queue_item3, queue_item1])
          end

          it "normalizes rearrangement where user enters position more than number of queue_items" do
            post :update_queue,user_id: current_user, queue_items: [{id: 1, position: 5}, {id: 2, position: 4}, {id: 3, position: 2}]
            expect(current_user.queue_items.last.position).to eq(3)
          end

          it "redirects to queue items index" do
            post :update_queue,user_id: current_user, queue_items: [{id: 1, position: 3}, {id: 2, position: 1}, {id: 3, position: 2}]
            expect(response).to redirect_to user_queue_items_path(current_user)
          end
        end

        context "update to rating" do
          it "updates already existing rating" do
            post :update_queue,user_id: current_user, queue_items: [{id: queue_item1.id, position: 3, rating: 2.0}, {id: 2, position: 1, rating: 5.0}, {id: 3, position: 2, rating: 1.0}]
            expect(queue_item1.reload.rating).to eq(2.0)
          end
        end
      end

      context "invalid input" do
        before do
          post :update_queue,user_id: current_user, queue_items: [{id: 1, position: 5}, {id: 2, position: 4.7}, {id: 3, position: 1}]
        end

        it "displays a flash message" do
          expect(flash['danger']).to be_present
        end

        it "redirects to queue index page" do
          expect(response).to redirect_to user_queue_items_path(current_user)
        end

        it "does not change queue item positions" do
          expect(current_user.reload.queue_items).to match_array([queue_item1, queue_item2, queue_item3])
        end
      end
    end
  end


  context "not logged in" do
    describe "GET index" do
      it_behaves_like "requires sign-in" do
        let(:action) {get :index, user_id: user1.id}
      end
    end

    describe "POST create" do
      it_behaves_like "requires sign-in" do
        let(:action) {post :create, user_id: user1.id, video_id: video3.id}
      end
    end

    describe "POST update" do
      it_behaves_like "requires sign-in" do
        let(:action) {post :update_queue,user_id: user1.id, queue_items: [{id: 1, position: 3}, {id: 2, position: 1}, {id: 3, position: 2}]}
      end
    end
  end

  context "queue_items that do not belong to user" do
    describe "POST update" do
      it "does not update where queue_items does not belong to signed-in user" do
        cookies.signed[:auth_token] = user2.auth_token
        post :update_queue,user_id: user2.id, queue_items: [{id: 4, position: 2}, {id: 5, position: 3}]
        expect(queue_item5.reload.position).to eq(1)
      end
    end
  end

end
