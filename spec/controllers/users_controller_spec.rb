require 'spec_helper'

describe UsersController do
  let(:user1) {Fabricate(:user)}  
  
  describe "GET new" do
    before do
      get :new
    end

    it "creates new user" do
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user) 
      end

      it "creates and saves user if params for user is valid" do
        expect(User.count).to eq(1)
      end 

      it "redirects to video show page after successful login" do 
        expect(response).to redirect_to(videos_path)
      end
    end

    context "invalid input" do
      before do
        post :create, user: {first_name: "Dan"}
      end

      it "redirects to new session page if user is not valid" do
        expect(response).to render_template(:new)      
      end

      it "does not save if user is invalid(no user in database)" do
        expect(User.count).to eq(0)
      end
    end
  end

  describe "GET show" do
    context "signed-in" do
      before do 
        sign_in(user1)
        get :show, id: user1
      end
      
      it "assigns user to user instance variable" do
        expect(assigns(:user)).to eq(user1)
      end

      it "renders show page" do
        expect(response).to render_template(:show)
      end
    end

    context "not signed-in" do
      it_behaves_like "requires sign-in" do
        let(:action) {get :show, id: user1}
      end
    end
  end
end


