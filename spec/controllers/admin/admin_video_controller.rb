require 'spec_helper'

describe Admin::VideosController do
  context "admin signed in" do
    let(:admin1) {Fabricate(:admin)}
    let!(:video1) {Fabricate(:video)}
    before {sign_in(admin1)}

    describe "GET new" do
      before {get :new}

      it "creates new video and assigns to video instance variable" do
        expect(assigns(:video)).to be_a_new(Video)
      end

      it "assigns all categories to categories instance variable" do
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)

        expect(assigns(:categories)).to match_array([category1,category2])
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      context "valid input" do
        before {post :create, video: Fabricate.attributes_for(:video)}
      
        it "creates new video variable" do
          expect(assigns(:video)).to be_a_new(Video)
        end

        it "creates a success flash message" do
          expect(flash["success"]).to be_present
        end

        it "redirects to video admin page" do
          expect(response).to redirect_to(new_admin_video_path)
        end
      end

      context "invalid input" do
        before {post :create, video: {title: "yes"}}

        it "displays a flash danger message" do
          expect(flash["danger"]).to be_present
        end

        it "redirects to video admin page" do
          expect(response).to redirect_to(new_admin_video_path)
        end  
      end
    end

    describe "GET edit" do
      before {get :edit, id: video1.slug}

      it "renders admin video edit page" do
        expect(response).to render_template :edit
      end
    end

    describe "PUT update" do
      context "valid input" do
        before {put :update, id: video1.slug, video: Fabricate.attributes_for(:video)}

        it "displays successful flash message" do
          expect(flash["success"]).to be_present
        end

        it "redirects to video show page" do
          expect(response).to redirect_to(video_path(video1))
        end
      end
    end

    describe "DELETE destroy" do
      before {delete :destroy, id: video1.slug}

      it "deletes video" do
        expect(Video.count).to eq(0)
      end

      it "redirects to video index page" do
        expect(response).to redirect_to(videos_path)
      end
    end

  end

  context "admin not signed in" do
    describe "GET new" do
      it_behaves_like "requires admin" do
        let(:action) {get :new}
      end
    end
  end

end