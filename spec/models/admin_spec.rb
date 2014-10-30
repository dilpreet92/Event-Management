require 'spec_helper'

describe Admin do

  let(:admin) { FactoryGirl.create :admin }
  subject { admin }

  context 'is invalid' do

    it 'when it has a invalid factory' do
      expect(admin).to be_valid
    end

    it 'when it is without a username' do
      expect{ admin.username }.not_to be_nil
    end

    it 'when it is without a password' do
      expect { admin.password }.not_to be_nil
    end

  end

end