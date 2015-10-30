def sign_in(user = nil)
  cookies.signed[:auth_token] = (user || Fabricate(:user)).auth_token
end

def current_user
  User.find_by(auth_token: cookies.signed[:auth_token])
end

def sign_out
  cookies.delete(:auth_token)
end

def feature_sign_in(user = nil)
  user1 = user || Fabricate(:user)
  visit login_path
  fill_in('E-mail:', :with => user1.email)
  fill_in('Password', :with => user1.password)
  click_button('Sign In')
end