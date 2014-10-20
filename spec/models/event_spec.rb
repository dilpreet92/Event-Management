require 'spec_helper'

describe Event do

  before :each do
    @event = FactoryGirl.create(:event)
  end
  
  it 'is invalid without name' do
  end

  it 'is invalid without address' do
  end

  it 'is invalid without city' do
  end

  it 'is invalid without country' do
  end

  it 'is invalid without contact number' do
  end

  it 'is invalid without description' do
  end

end