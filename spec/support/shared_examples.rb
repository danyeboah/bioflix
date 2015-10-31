shared_examples "requires sign-in" do
  it "redirects to login page" do
    sign_out 
    action
    expect(response).to redirect_to login_path 
  end
end
