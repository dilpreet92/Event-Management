require 'spec_helper'

describe Admin do

  let!(:admin) { FactoryGirl.build :admin }

  describe 'validation' do

    it 'it has a invalid factory' do
      expect(admin).to be_valid
    end

    it { expect(admin).to validate_presence_of(:username) }
    it { expect(admin).to validate_presence_of(:password) }
    it { expect(admin).to validate_uniqueness_of(:username) }
    it { expect(admin.password.to_s).to match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$\z/) }
  
  end

end