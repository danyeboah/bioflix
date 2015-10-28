require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    before do
      get :new
    end

    it "redirects to show videos page if logged in" do
      user = Fabricate(:user)
      cookies.signed[:auth_token] = user.auth_token
      get :new
      expect(response).to redirect_to(videos_path)
    end
    
    it "renders new template if not logged in" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:user) {Fabricate(:user)}

    context "user authenticates" do
      before do
        post :create, email: user.email, password: user.password, remember_me: "1"
      end

      it "displays successful flash message" do
        expect(flash["success"]).not_to be_nil
      end

      it "assigns a permanent cookie if remember me selected" do
        expect(cookies.signed[:auth_token]).to eq(user.auth_token)
      end

      it "redirects to video index page" do
        expect(response).to redirect_to(videos_path)
      end
    end

    context "unsuccessful authentication(invalid credentials)" do
      before do 
        post :create, email: user.email
      end

      it "redirects to login page" do
        expect(response).to redirect_to(login_path)
      end
      
      it "displays error flash message" do
        expect(flash["danger"]).to be_present
      end

      it "creates no session" do
        expect(cookies.signed[:auth_token]).to be_nil
      end
    end
  end


  describe "GET destroy" do
    before do
      cookies.signed[:auth_token] = Fabricate(:user).auth_token
      get :destroy

    end

    it "destroys cookie" do
      expect(cookies.signed[:auth_token]).to be_nil
    end
    
    it "displays flash message of successful logout" do
      expect(flash["success"]).to be_present
    end

    it "redirects to root page" do
      expect(response).to redirect_to(root_path)
    end
  end





  
end
