require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video1) {Fabricate(:video)}
    let(:user1) {Fabricate(:user)}

    context "authenticated user" do
      before do
        cookies.signed[:auth_token] = user1.auth_token
      end

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

    context "unauthenticated user" do
      it "should redirect to login page" do
        post :create, video_id: video1.slug, review: Fabricate.attributes_for(:review)
        expect(response).to redirect_to(login_path)
      end
    end
    
  end

end
