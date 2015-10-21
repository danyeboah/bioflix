require 'spec_helper'

describe Queue_item do
  it {should belong_to(:video)}
  it {should belong_to(:user)}
end