require 'spec_helper'

describe ReviewsController do
  let(:video1) {Fabricate(:video)}
  let(:user1) {Fabricate(:user)}
  let(:review1) {Fabricate(:review)}

  context "authenticated user" do
    before do
      cookies.signed[:auth_token] = user1.auth_token
    end

    describe "POST create" do
      it "should assign the selected video to video instance variable" do
        post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        expect(assigns(:video)).to eq(video1)
      end

      context "valid review" do
        before do
          post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        end
        
        it "should save review to database" do
          expect(video1.reviews.count).to eq(1)
        end

        it "should associate review to current video" do
          expect(Review.first.video).to eq(video1)
        end

        it "should associate review to current user" do
          expect(Review.first.user).to eq(user1)
        end

        it "should create flash message" do
          expect(flash["success"]).to be_present
        end
      
        it "should redirect to video show page" do
          expect(response).to redirect_to(video_path(video1))
        end

      end

      context "invalid review" do
        before do 
          post :create, video_id: video1.slug, review: {content: "Yes"}
        end

        it "should not save review to database" do
          expect(video1.reviews.count).to eq(0)
        end
        
        it "should show flash error message" do
          expect(flash["danger"]).to be_present
        end

        it "should render video show page" do
          expect(response).to render_template('videos/show')
        end
      end
    end

    describe "GET edit" do
      before do
        get :edit, video_id: video1, id: review1.id 
      end
        
      it "should assign video to video instance variable" do
        expect(assigns(:video)).to eq(video1)
      end

      it "should assign review to review instance variable" do
        expect(assigns(:review)).to eq(review1)
      end

      it "should render edit page" do
        expect(response).to render_template :edit
      end
    end

    describe "PATCH update" do
      context "valid input" do
        before do
          patch :update, review: {content: "cool", rating: 4}, video_id: video1, id: review1.id
        end

        it "should display successful flash" do
          expect(flash["success"]).to be_present
        end
        
        it "should update review" do
          expect(review1.reload.content).to eq("cool")
        end

        it "should redirect to video show page" do
          expect(response).to redirect_to video_path(video1)
        end
      end

      context "invalid input" do
        before do
          patch :update, review: {content: "cool", rating: nil}, video_id: video1, id: review1.id
        end

        it "should not update review" do
          expect(review1.reload.content).not_to eq("cool")
        end

        it "should display flash danger message" do
          expect(flash["danger"]).to be_present
        end

        it "should render video show page" do
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

      it "should delete review" do
        expect(video1.reviews.count).to eq(0)
      end

      it "should display flash success message" do
        expect(response).to redirect_to video_path(video1)
      end
    end

  end

  context "unauthenticated user" do
    describe "POST create" do 
      it "should redirect to login page" do
        post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET edit" do
      it "should redirect to login page" do
        get :edit, video_id: video1, id: review1.id 
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PATCH update" do
      it "should redirect to login page" do
        patch :update, review: {content: "cool", rating: 4}, video_id: video1, id: review1.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "DELETE destroy" do
      it "should redirect to login page" do
        delete :destroy, video_id: video1, id: review1.id
        expect(response).to redirect_to(login_path)
      end
    end

  end
end
