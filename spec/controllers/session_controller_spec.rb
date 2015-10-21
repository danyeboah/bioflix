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

      it "should assign a permanent cookie if remember me selected" do
        expect(cookies.signed[:auth_token]).to eq(user.auth_token)
      end

      it "should redirect to video show page" do
        expect(response).to redirect_to(videos_path)
      end
    end

    context "unsuccessful authentication(invalid credentials)" do
      before do 
        post :create, email: user.email
      end

      it "should redirect to login page" do
        expect(response).to redirect_to(login_path)
      end
      
      it "should display error flash message" do
        expect(flash["error"]).not_to be_nil
      end

      it "should create no session" do
        expect(cookies.signed[:auth_token]).to be_nil
      end
    end
  end


  describe "GET destroy" do
    before do
      cookies.signed[:auth_token] = Fabricate(:user).auth_token
      get :destroy

    end

    it "should destroy cookie" do
      expect(cookies.signed[:auth_token]).to be_nil
    end
    
    it "should display flash message of successful logout" do
      expect(flash["success"]).not_to be_nil
    end

    it "should redirect to root page" do
      expect(response).to redirect_to(root_path)
    end
  end





  
end
