require 'spec_helper'

describe Rsvp do

  let!(:rsvp) { FactoryGirl.build :rsvp }

  describe 'associations' do
    it { expect(rsvp).to belong_to(:session) }
    it { expect(rsvp).to belong_to(:user) }
  end

end