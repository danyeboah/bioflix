require 'spec_helper'

describe ReviewsController do
  let(:video1) {Fabricate(:video)}
  let(:user1) {Fabricate(:user)}
  let(:review1) {Fabricate(:review)}

  context "authenticated user" do
    before { sign_in(user1)}

    describe "POST create" do
      it "assigns the selected video to video instance variable" do
        post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        expect(assigns(:video)).to eq(video1)
      end

      context "valid review" do
        before do
          post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        end
        
        it "saves review to database" do
          expect(video1.reviews.count).to eq(1)
        end

        it "associates review to current video" do
          expect(Review.first.video).to eq(video1)
        end

        it "associates review to current user" do
          expect(Review.first.user).to eq(user1)
        end

        it "creates flash message" do
          expect(flash["success"]).to be_present
        end
      
        it "redirects to video show page" do
          expect(response).to redirect_to(video_path(video1))
        end

      end

      context "invalid review" do
        before do 
          post :create, video_id: video1.slug, review: {content: "Yes"}
        end

        it "does not save review to database" do
          expect(video1.reviews.count).to eq(0)
        end
        
        it "shows flash error message" do
          expect(flash["danger"]).to be_present
        end

        it "renders video show page" do
          expect(response).to render_template('videos/show')
        end
      end
    end

    describe "GET edit" do
      before do
        get :edit, video_id: video1, id: review1.id 
      end
        
      it "assigns video to video instance variable" do
        expect(assigns(:video)).to eq(video1)
      end

      it "assigns review to review instance variable" do
        expect(assigns(:review)).to eq(review1)
      end

      it "renders edit page" do
        expect(response).to render_template :edit
      end
    end

    describe "PATCH update" do
      context "valid input" do
        before do
          patch :update, review: {content: "cool", rating: 4}, video_id: video1, id: review1.id
        end

        it "displays successful flash" do
          expect(flash["success"]).to be_present
        end
        
        it "updates review" do
          expect(review1.reload.content).to eq("cool")
        end

        it "redirects to video show page" do
          expect(response).to redirect_to video_path(video1)
        end
      end

      context "invalid input" do
        before do
          patch :update, review: {content: "cool", rating: nil}, video_id: video1, id: review1.id
        end

        it "does not update review" do
          expect(review1.reload.content).not_to eq("cool")
        end

        it "displays flash danger message" do
          expect(flash["danger"]).to be_present
        end

        it "renders video show page" do
          expect(response).to render_template 'videos/show'
        end
      end
    end

    describe "DELETE destroy" do
      before do
        review1
        video1
        delete :destroy, video_id: video1, id: review1.id
      end

      it "deletes review" do
        expect(video1.reviews.count).to eq(0)
      end

      it "displays flash success message" do
        expect(response).to redirect_to video_path(video1)
      end
    end

  end

  context "unauthenticated user" do
    describe "POST create" do 
      it_behaves_like "requires sign-in" do
        let(:action) {post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)}
      end
    end

    describe "GET edit" do
      it_behaves_like "requires sign-in" do
        let(:action) {get :edit, video_id: video1, id: review1.id} 
      end
    end

    describe "PATCH update" do
      it_behaves_like "requires sign-in" do
        let(:action) {patch :update, review: {content: "cool", rating: 4}, video_id: video1, id: review1.id}
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "requires sign-in" do
        let(:action) {delete :destroy, video_id: video1, id: review1.id}
      end
    end

  end
end
