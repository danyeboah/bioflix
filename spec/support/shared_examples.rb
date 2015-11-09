shared_examples "requires sign-in" do
  it "redirects to login page" do
    sign_out 
    action
    expect(response).to redirect_to login_path 
  end
end

shared_examples "requires admin" do
  before do
    sign_out
    sign_in
    action
  end

  it "redirects to root path" do
    expect(response).to redirect_to root_path
  end 

  it "sets flash error message" do
    expect(flash["danger"]).to be_present
  end
end
