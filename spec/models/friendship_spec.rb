require 'spec_helper'

describe Friendship do
  it {should belong_to(:leader)}
  it {should belong_to(:follower)}
end