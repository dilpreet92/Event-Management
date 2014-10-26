require 'spec_helper'

describe Event do
  
  let(:user) { FactoryGirl.create :user }
  subject { user }
  let(:event) { FactoryGirl.create(:event, :user => user) }
  subject { event }

  context 'is invalid' do

    it ' when it has a invalid factory' do
      expect(event).to be_valid
    end

    it ' when it is without name' do
      expect { event.name }.not_to be_nil
    end

    it 'when it is without address' do
      expect { event.address }.not_to be_nil
    end

    it 'when it is without city' do
      expect { event.city }.not_to be_nil
    end

    it 'when it is without country' do
      expect { event.country }.not_to be_nil
    end

    it 'when it is without contact number' do
      expect { event.contact_number }.not_to be_nil
    end

    it 'when it is without description' do
      expect { event.description }.not_to be_nil
    end

    it 'when it has a description of length greater than 500' do
      expect(event.description.length).to be <= 500
    end

    it 'when it is without a user' do
      expect { event.user }.not_to be_nil
    end

  end

  context '.sessions' do

    it 'should return sessions' do
      expect { event.sessions }.not_to raise_error
    end

  end

  context '.attendes' do

    it 'should return users' do
      expect { event.attendes }.not_to raise_error
    end
  end

  context 'raises exception when called with' do

    it '#delete' do
      expect { event.delete }.to raise_error
    end

    it '#destroy' do
      expect { event.destroy }.to raise_error
    end

    it '.delete_all' do
      expect { Event.delete_all }.to raise_error
    end

    it '.destroy_all' do
      expect { Event.destroy_all }.to raise_error
    end

  end  

  context '.live_and_upcoming' do

    it 'should return live_and_upcoming events' do
      event = Event.where("events.end_date >= ?", Time.current).first
      expect(Event.live_and_upcoming).to include(event)
    end

    it 'should not return past_events' do
      event = Event.where("events.end_date < ?", Time.current).first
      expect(Event.live_and_upcoming).not_to include(event)
    end

  end

  context '.past' do

    it 'should return past_events' do
      event = Event.where("events.end_date < ?", Time.current).first
      expect(Event.past).to include(event)
    end

    it 'should not return live_and_upcoming events' do
      event = Event.where("events.end_date >= ?", Time.current).first
      expect(Event.past).not_to include(event)
    end

  end

  context '.enabled' do

    it 'should return enabled events' do
      enabled_event =  FactoryGirl.create(:event, enable: true)
      expect(Event.enabled).to include(enabled_event)
    end

    it 'should not return disabled events' do
      disabled_event = FactoryGirl.create(:event, enable: false)
      expect(Event.enabled).not_to include(disabled_event)
    end

  end

  context '.search' do

    let(:event_session_association) { Event.enabled.live_and_upcoming.eager_load(:sessions) }
    subject { event_session_association }

    it 'should return events as per the name' do
      query = 'dilpreet'
      expect(event_session_association.search(query.downcase)).to include(event)
    end

    it 'should return events as per the city' do
      query = 'Delhi'
      expect(event_session_association.search(query.downcase)).to include(event)
    end

    it 'should return events as per the country' do
      query = 'IN'
      expect(event_session_association.search(query.downcase)).to include(event)
    end

    it 'should return event as per the topic of the session' do
      query = 'dilpreet'
      expect(event_session_association.search(query.downcase)).to include(event)
    end

  end

  context '#live_and_upcoming?' do

    it 'should return true if event is live_and_upcoming' do
      event = Event.where("end_date >= ?", Time.current).first
      expect(event.live_and_upcoming?).to be_true
    end

    it 'should return false if event is past' do
      event = Event.where("end_date < ?", Time.current).first
      expect(event.live_and_upcoming?).to be_false
    end

  end

  context '#past?' do

    it 'should return true if event is past' do
      event = Event.where("end_date < ?", Time.current).first
      expect(event.live_and_upcoming?).to be_true
    end

    it 'should return false if event is live_and_upcoming' do
      event = Event.where("end_date >= ?", Time.current).first
      expect(event.live_and_upcoming?).to be_true
    end
  end

  context '#owner?' do

    it 'should return true if current user is owner of event' do
      expect(event.owner?(user)).to be_true
    end

    it 'should return false if current user is not owner' do
      user = FactoryGirl.create(:user)
      expect(event.owner?(user)).to be_false
    end

  end

end