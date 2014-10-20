require 'spec_helper'

describe Session do

  before :each do
    @event = FactoryGirl.create(:event)
    @session = @event.create(:session)
  end

  it 'has a valid factory' do
    @session.should be_valid
  end
  
  it 'is invalid without topic' do
    @session.topic.should_not == nil
  end

  it 'is invalid without location' do
    @session.location.should_not == nil
  end

  it 'is invalid without description' do
    @session.description.should_not == nil
  end

  it 'cannot be deleted' do
    expect { @session.delete }.to raise_error
  end

  it 'cannot be destroyed' do
    expect { @session.destroy }.to raise_error
  end

  it 'cannot be deleted' do
    expect { Session.delete_all }.to raise_error
  end

  it 'cannot be destroyed' do
    expect { Session.destroy_all }.to raise_error
  end

  it 'returns true if live and upcoming sessions' do
  end

end