require 'spec_helper'

describe Admin::CategoriesController do
  context "user is admin" do
    let!(:admin1) {Fabricate(:admin)}
    let!(:category4) {Fabricate(:category)}

    before {sign_in(admin1)}

    describe "GET new" do
      let!(:category1) {Fabricate(:category)}
      let!(:category2) {Fabricate(:category)}

      before {get :new}
      it "creates a new category" do
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "assigns all categories to all_categories variable" do
        expect(assigns(:all_categories)).to match_array([category1, category2, category4])
      end

      it "renders admin category new page" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST create" do
      context "valid input" do
        before {post :create, category: Fabricate.attributes_for(:category)}

        it "displays a success flash message" do
          expect(flash["success"]).to be_present
        end

        it "redirects to new admin page" do
          expect(response).to redirect_to new_admin_category_path
        end
      end

      context "invalid input" do
        let!(:category3) {Fabricate(:category,name: "comedy")}
        before do
          post :create, category: {name: "comedy" } 
        end
        it "displays a danger flash message" do
          expect(flash["danger"]).to be_present
        end

        it "redirects to new admin page" do
          expect(response).to redirect_to new_admin_category_path
        end
      end
    end

    describe "GET edit" do
      before {get :edit, id: category4.slug}

      it "assigns category to edit variable" do
        expect(assigns(:category)).to eq(category4)
      end

      it "renders edit category page" do
        expect(response).to render_template :edit
      end

    end

    describe "PUT update" do
      context "valid input" do
        before {put :update, id: category4.slug, category:Fabricate.attributes_for(:category)}

        it "shows flash success message" do
          expect(flash["success"]).to be_present
        end

        it "redirects to new category page" do
          expect(response).to redirect_to new_admin_category_path
        end
      end

      context "invalid input" do
        let!(:category5) {Fabricate(:category,name: "action")}

        before {put :update, id: category4.slug, category: {name: "action"}}
        it "shows flash danger message" do
          expect(flash.now["danger"]).to be_present
        end

        it "renders edit page" do
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      before {delete :destroy, id: category4.slug}

      it "destroys category" do
        expect(Category.all).not_to include(category4)
      end

      it "redirects to new admin category page" do
        expect(response).to redirect_to(new_admin_category_path)
      end
    end
  end

  context "user not admin" do
    describe "GET new" do
      it_behaves_like "requires admin" do
        let(:action) {get :new}
      end
    end
  end

end