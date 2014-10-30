require 'spec_helper'

describe Session do

  let(:event) { FactoryGirl.create(:event) }
  subject { event }
  let(:session) { FactoryGirl.create(:session, :event => event)}
  subject { session }

  context 'is invalid' do

    it 'when it has a invalid factory' do
      expect(session).to be_valid
    end

    it 'when it is without topic' do
      expect { session.topic }.not_to be_nil
    end

    it 'when it is without location' do
      expect { session.location }.not_to be_nil
    end

    it 'when it is without description' do
      expect { session.description }.not_to be_nil
    end

    it 'when it is without event id' do
      expect { session.event_id }.not_to be_nil
    end

    it 'when it has a description of length greater than 250' do
      expect(session.description.length).to be <= 250
    end

  end

  context '.rsvps' do

    it 'should return rsvps' do
      expect { session.rsvps }.not_to raise_error
    end

  end

  context '.attendes' do

    it 'should return attendes' do
      expect { session.attendes }.not_to raise_error
    end

  end

  context 'raises exception when called with' do

    it '#delete' do
      expect { session.delete }.to raise_error
    end

    it '#destroy' do
      expect { session.destroy }.to raise_error
    end

    it '.delete_all' do
      expect { Session.delete_all }.to raise_error
    end

    it '.destroy_all' do
      expect { Session.destroy_all }.to raise_error
    end

  end  
  
  context 'when called with #upcoming?' do

    it 'should return true if session is upcoming' do
      expect { session.upcoming? }.to be_true
    end

    it 'should return false if session is past' do
      session = Session.where("end_date < ?", Time.current).first
      expect { session.upcoming? }.to be_false
    end

  end

  context 'when called with .enabled' do

    it 'should return enabled events' do
      expect(Session.enabled).to include(session)
    end

    it 'should not return disabled events' do
      session = Session.where(enable: false).first
      expect(Session.enabled).not_to include(session)
    end

  end

end