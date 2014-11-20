require 'spec_helper'

describe Event do
  
  let!(:user) { FactoryGirl.build :user }
  let!(:event) { FactoryGirl.build(:event, :user => user) }

  describe 'validations' do

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

  end

  describe 'associations' do

    it { expect(event).to belong_to(:user) }
    it { expect(event).to have_many(:sessions) }
    it { expect(event).to have_many(:attendes).through(:sessions).source(:attendes) }
    it { should have_attached_file(:logo) }

  end

  describe 'callbacks' do 
    let!(:user) { FactoryGirl.create :user }
    let!(:event) { FactoryGirl.create(:event, :user => user) }

    it 'should call check_all_sessions_in_range before save' do
      expect(event).to receive(:check_all_sessions_in_range?) 
      event.save
    end

    describe '#ensure_all_sessions_in_range?' do
      
      context 'when true' do
        it 'should return true' do
          expect(event.save).to be_true
        end
      end

      context 'when false' do
        let!(:session) { FactoryGirl.create(:session, :event => event ) }
        it 'should add error message' do
          event.update_attribute(:start_date, session.start_date + 1.day )
          event.sessions(true)
          expect(event.save).to be_false
          expect(event.errors).not_to be_nil
          expect(event.errors[:base]).to include 'Event cannot be updated as event has sessions outside the given interval'
        end
      end
    end

    it 'should call valid event date before save' do
      expect(event).to receive(:valid_event_date?)
      event.save
    end

    describe '#event_date_valid' do

        before do
          event.start_date = Time.current - 1.day
        end

        context 'when date invalid' do
          it { expect(event.errors).not_to be_nil }
        end

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

  describe 'scopes' do

    context '.live_or_upcoming' do

      it 'should return live_or_upcoming events' do
        event.save
        expect(Event.live_or_upcoming).to include(event)
      end

      it 'should not return past_events' do
        event.update_attribute(:end_date, Time.current - 1.day )
        expect(Event.live_or_upcoming).not_to include(event)
      end

    end

    context '.past' do

      it 'should return past_events' do
        event.save
        event.update_attribute(:start_date, (Time.current - 2.day))
        event.update_attribute(:end_date, (Time.current - 1.day) )
        expect(Event.past).to include(event)
      end

      it 'should not return live_or_upcoming events' do
        event.save
        expect(Event.past).not_to include(event)
      end

    end

    context '.enabled' do

      it 'should return enabled events' do
        event.save
        expect(Event.enabled).to include(event)
      end

      it 'should not return disabled events' do
        event.update_attribute(:enable, false)
        expect(Event.enabled).not_to include(event)
      end
    end

    context '.search' do

      let!(:event_session_association) { Event.enabled.live_or_upcoming.eager_load(:sessions) }
      before do
        event.save
      end
      it 'should return events as per the name' do
        query = 'dilpreet'
        expect(event_session_association.search(query.downcase)).to include(event)
      end

      it 'should return events as per the city' do
        query = 'Delhi'
        expect(event_session_association.search(query.downcase)).to include(event)
      end

      it 'should return events as per the country' do
        query = 'India'
        expect(event_session_association.search(query.downcase)).to include(event)
      end

      it 'should return event as per the topic of the session' do
        query = 'dilpreet'
        expect(event_session_association.search(query.downcase)).to include(event)
      end
    end

  end

  describe '#instance_methods' do

    context '#live_or_upcoming?' do

      it 'should return true if event is live_or_upcoming' do
        expect(event.live_or_upcoming?).to be_true
      end

      it 'should return false if event is past' do
        event.update_attribute(:end_date, (Time.current - 1.day) ) 
        expect(event.live_or_upcoming?).to be_false
      end

    end

    context '#past?' do

      it 'should return true if event is past' do
        event.update_attribute(:end_date, (Time.current - 1.day) )
        expect(event.past?).to be_true
      end

      it 'should return false if event is live_or_upcoming' do
        event.save
        expect(event.past?).to be_false
      end
    end

    context '#owner?' do

      it 'should return true if current user is owner of event' do
        expect(event.owner?(user)).to be_true
      end

      it 'should return false if current user is not owner' do
        user = FactoryGirl.build(:user, id: 500)
        expect(event.owner?(user)).to be_false
      end
    end

  end

end