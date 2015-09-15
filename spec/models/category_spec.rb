require 'spec_helper'

describe Category do
  it {should have_many(:videos)}

  describe '#recent_videos' do
    before :each do
      @comedy = Category.create(name: "Comedy")
    end  

    it 'should return 6 videos ordered by recency(created) where there are more than 6 videos' do
      The_League = Video.create(title: "The League", description: "Bros", category: @comedy, created_at: 1.day.ago)
      Futurama = Video.create(title: "Futurama", description: "Cool Story", category: @comedy, created_at: 3.days.ago)
      South_Park = Video.create(title: "South Park", description: "Too funny",category: @comedy, created_at: 8.days.ago)
      The_Future = Video.create(title: "The Future", description: "Cool Baby",category: @comedy, created_at: 2.days.ago)
      Scandal = Video.create(title: "Scandal", description: "nice", category: @comedy, created_at: 5.days.ago)
      Lost = Video.create(title: "Lost", description: "sweet", category: @comedy, created_at: 6.days.ago)

      expect(@comedy.recent_videos(6)).to eq([The_League,The_Future,Futurama,Scandal,Lost,South_Park])
    end

    it 'should return the exact number of videos where videos are less than 6' do
      The_League = Video.create(title: "The League", description: "Bros", category: @comedy, created_at: 1.day.ago)
      Futurama = Video.create(title: "Futurama", description: "Cool Story", category: @comedy, created_at: 8.days.ago)
      South_Park = Video.create(title: "South Park", description: "Too funny", category: @comedy, created_at: 3.days.ago)
      The_Future = Video.create(title: "The Future", description: "Cool Baby", category: @comedy, created_at: 4.days.ago)

      expect(@comedy.recent_videos(6).count).to eq(4)
    end

    it 'should return an empty array where there are no videos' do
      expect(@comedy.recent_videos(6)).to eq([])
    end
  end
end
