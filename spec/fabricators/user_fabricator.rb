Fabricator(:user) do
  first_name {Faker::Name.first_name}
  last_name {Faker::Name.last_name}
  email {Faker::Internet.email}
  password {"password"}
  password_confirmation {"password"}
end

Fabricator(:user2) do
  first_name {Faker::Name.first_name}
  last_name {Faker::Name.last_name}
  email {Faker::Internet.email}
end




