require 'spec_helper'

describe QueueItem do
  it {should belong_to(:video)}
  it {should belong_to(:user)}
  it {should validate_numericality_of(:position)}
end