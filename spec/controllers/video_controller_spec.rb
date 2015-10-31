require 'spec_helper'

describe VideosController do
  let!(:video1) {Fabricate(:video, title: "The end")}
  let(:video2) {Fabricate(:video)}
  let(:review1) {Fabricate(:review)}
  let(:review2) {Fabricate(:review)}


  context "user signed in" do
    before {sign_in}

    describe "GET show" do
      before do
        get :show, id: video1
      end

      it "assigns a video to video instance variable if it exists" do
        expect(assigns(:video)).to eq(video1)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end

      it "assigns a new review object to review instance variable" do
        expect(assigns(:review)).to be_a_new(Review)
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
      it_behaves_like "requires sign-in" do
        let(:action) {get :show, id: video1.slug}
      end
    end 
  end

end
