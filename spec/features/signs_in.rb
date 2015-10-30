require 'spec_helper'

feature "signing in" do
  scenario "with existing username and password" do
    daniel = Fabricate(:user)
    feature_sign_in(daniel)
    expect(page).to have_content(daniel.first_name)
    
  end
  
end