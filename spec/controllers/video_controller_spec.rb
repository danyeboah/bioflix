require 'spec_helper'

describe VideosController do
  let!(:video1) {Fabricate(:video, title: "The end")}
  let(:video2) {Fabricate(:video)}
  let(:review1) {Fabricate(:review)}
  let(:review2) {Fabricate(:review)}


  context "user signed in" do
    before do
      user = Fabricate(:user)
      cookies.signed[:auth_token] = user.auth_token
    end

    describe "GET show" do
      before do
        get :show, id: video1.slug
      end

      it "assigns a video to video instance variable if it exists" do
        expect(assigns(:video)).to eq(video1)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "assigns a new review object to review instance variable" do
        expect(assigns(:review)).to be_new_record
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end
  
    describe "POST search" do
      before do
        post :search, query: "The end"
      end

      it "assigns videos found to videos instance variable" do
        expect(assigns(:videos)).to eq([video1])
      end

      it "renders search template" do
        expect(response).to render_template(:search)
      end
    end 
  end

  context "user not signed in" do
    describe "GET show" do
      it "redirect to login path" do
        get :show, id: video1.slug
        expect(response).to redirect_to(login_path)
      end
    end 
  end

end
