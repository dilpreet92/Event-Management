require 'spec_helper'

describe Rsvp do

  let(:rsvp) { FactoryGirl.create :rsvp }
  subject { rsvp }
  
  context 'is invalid' do

    it 'when it has a invalid factory' do
      expect(rsvp).to be_valid
    end

    it 'when it is without a user' do
      expect { rsvp.user }.not_to be_nil
    end

    it 'when it is without a session' do
      expect { rsvp.session }.not_to be_nil
    end

  end

end