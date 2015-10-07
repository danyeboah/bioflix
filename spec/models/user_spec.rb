require 'spec_helper'

describe User do
  it {should validate_presence_of(:first_name)}
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:email)} 
  it {should validate_uniqueness_of(:email)}  #### come back to fix this
  it {should validate_length_of(:password).on(:create)}
  it {should validate_presence_of(:password).on(:create)}
  it {should have_secure_password}
  it {should have_many(:reviews)}

end
