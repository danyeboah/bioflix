require 'spec_helper'

describe UsersController do
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
    let(:user1) {Fabricate(:user)}

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
end


