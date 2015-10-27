require 'spec_helper'

describe Category do
  it {should have_many(:videos)}

  describe '#recent_videos' do
    
    let!(:comedy) {Category.create(name: "Comedy")}
    let(:the_league) {Video.create(title: "The League", description: "Bros", category: comedy, created_at: 1.day.ago)
}  
    let(:futurama) {Video.create(title: "Futurama", description: "Cool Story", category: comedy, created_at: 3.days.ago)
}
    let(:south_park) {Video.create(title: "South Park", description: "Too funny",category: comedy, created_at: 8.days.ago)
}
    let(:scandal) {Video.create(title: "Scandal", description: "nice", category: comedy, created_at: 5.days.ago)
}
    let(:lost) {Video.create(title: "Lost", description: "sweet", category: comedy, created_at: 6.days.ago)
}

    let(:the_future) {Video.create(title: "The Future", description: "Cool Baby", category: comedy, created_at: 2.days.ago)}


    it 'returns 6 videos ordered by recency(created) where there are more than 6 videos' do
      the_league
      the_future
      futurama
      scandal
      lost
      south_park

      expect(comedy.recent_videos(6)).to eq([the_league,the_future,futurama,scandal,lost,south_park])
    end

    it 'returns the exact number of videos where videos are less than 6' do
      futurama
      south_park
      the_league
      scandal
      expect(comedy.recent_videos(6).count).to eq(4)
    end

    it 'returns an empty array where there are no videos' do
      expect(comedy.recent_videos(6)).to eq([])
    end
  end
end
