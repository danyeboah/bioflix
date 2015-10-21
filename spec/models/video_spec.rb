require 'spec_helper'

describe Video do
  it {should belong_to(:category)} 
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should have_many(:reviews).order("created_at DESC")}

  describe "search_by_title" do
    let(:south_park) {Video.create(title: "South Park", description: "Too funny", small_cover_url: "/tmp/south_park.jpg")
}
    let(:the_league) {Video.create(title: "The League", description: "Bros", small_cover_url: "Videos/TheLeague_small.jpg")}
    let(:futurama) {Video.create(title: "Futurama", description: "Cool Story", small_cover_url: "/tmp/futurama.jpg")}
    let(:the_future) {Video.create(title: "The Future", description: "Cool Baby", small_cover_url: "/tmp/futurama.jpg")}

  

    it "returns an empty array where no match" do
      result = Video.search_by_title('boss')
      expect(result).to eq([])
    end

    it "returns an array with a single item if there is perfect match" do
      result = Video.search_by_title('South Park')    
      expect(result).to eq([south_park])
    end
    
    it "returns an array with a single item if there is a partial match" do
      result = Video.search_by_title('rama')    
      expect(result).to eq([futurama])
    end

    it "returns an array of multiple items if there are partial matches" do
      result = Video.search_by_title('Futur')    
      expect(result).to eq([futurama, the_future])
    end

  end
end
