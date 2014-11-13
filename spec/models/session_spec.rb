require 'spec_helper'

describe Session do

  let!(:event) { FactoryGirl.build(:event) }
  let!(:session) { FactoryGirl.build(:session, :event => event) }

  describe '#validations' do

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

    describe '#session_start_date' do

      context 'when invalid' do
        before do
          session.start_date = Time.current - 1.day
          session.save
        end
          it { expect(session.errors).not_to be_nil }
      end

    end

    describe '#session_end_date' do
      context 'when invalid' do
        before do
          session.end_date = Time.current - 1.day
          session.save
        end
        it { expect(session.errors).not_to be_nil }
      end
    end

  end

  describe '#associations' do

    it { expect(session).to belong_to(:event) }
    it { expect(session).to have_many(:rsvps) }
    it { expect(session).to have_many(:attendes).through(:rsvps).source(:user) }
  
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
      expect(session.upcoming?).to be_true
    end

    it 'should return false if session is past' do
      session.update_attribute(:end_date, (Time.current - 1.day))
      expect(session.upcoming?).to be_false
    end

  end

  describe '.scopes' do

    context 'when called with .enabled' do

      it 'should return enabled events' do
        session.save
        expect(Session.enabled).to include(session)
      end

      it 'should not return disabled events' do
        session.update_attribute(:enable, false)
        expect(Session.enabled).not_to include(session)
      end

    end

  end

end