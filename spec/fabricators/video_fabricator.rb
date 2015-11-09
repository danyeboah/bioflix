Fabricator(:video) do 
  title {Faker::Lorem.word}
  description {Faker::Lorem.paragraph}
  category
  small_cover {Faker::Lorem.word}
  large_cover {Faker::Lorem.word}
  video_url {Faker::Internet.url}
end