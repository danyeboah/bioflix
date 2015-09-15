require 'spec_helper'

describe Video do
  it {should belong_to(:category)} 
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe "search_by_title" do
    before :each do
      The_League = Video.create(title: "The League", description: "Bros", small_cover_url: "Videos/TheLeague_small.jpg")
      Futurama = Video.create(title: "Futurama", description: "Cool Story", small_cover_url: "/tmp/futurama.jpg")
      South_Park = Video.create(title: "South Park", description: "Too funny", small_cover_url: "/tmp/south_park.jpg")
      The_Future = Video.create(title: "The Future", description: "Cool Baby", small_cover_url: "/tmp/futurama.jpg")

    end

    it "returns an empty array where no match" do
      result = Video.search_by_title('boss')
      expect(result).to eq([])
    end

    it "returns an array with a single item if there is perfect match" do
      result = Video.search_by_title('South Park')    
      expect(result).to eq([South_Park])
    end
    
    it "returns an array with a single item if there is a partial match" do
      result = Video.search_by_title('rama')    
      expect(result).to eq([Futurama])
    end

    it "returns an array of multiple items if there are partial matches" do
      result = Video.search_by_title('Futur')    
      expect(result).to eq([Futurama, The_Future])
    end

  end
end
