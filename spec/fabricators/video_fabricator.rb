Fabricator(:video) do 
  title {Faker::Lorem.word}
  description {Faker::Lorem.paragraph}
  category {Fabricate(:category)}
end