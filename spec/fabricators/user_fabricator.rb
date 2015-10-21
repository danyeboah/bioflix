Fabricator(:user) do
  first_name {Faker::Name.first_name}
  last_name {Faker::Name.last_name}
  email {Faker::Internet.email}
  password {"password"}
  password_confirmation {"password"}
end

Fabricator(:invalid_user, from: :user) do
  password nil
  password_confirmation nil
end




