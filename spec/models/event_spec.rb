require 'spec_helper'

describe Event do

  before :each do
    @event = FactoryGirl.create(:event)
  end

  it 'has a valid factory' do
    @event.should be_valid
  end
  
  it 'is invalid without name' do
    @event.name.should_not == nil
  end

  it 'is invalid without address' do
    @event.address.should_not == nil
  end

  it 'is invalid without city' do
    @event.city.should_not == nil
  end

  it 'is invalid without country' do
    @event.country.should_not == nil
  end

  it 'is invalid without contact number' do
    @event.contact_number == nil
  end

  it 'is invalid without description' do
    @event.description == nil
  end

  it 'cannot be deleted' do
    expect { @event.delete }.to raise_error
  end

  it 'cannot be destroyed' do
    expect { @event.destroy }.to raise_error
  end

  it 'cannot be deleted' do
    expect { Event.delete_all }.to raise_error
  end

  it 'cannot be destroyed' do
    expect { Event.destroy_all }.to raise_error
  end

  it 'returns true if live and upcoming events' do
  end

end