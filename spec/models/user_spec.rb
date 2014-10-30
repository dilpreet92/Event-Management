require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create :user }
  subject { user }
  let(:event) { FactoryGirl.create(:event, :user => user) }
  subject { event }
  let(:session) { FactoryGirl.create(:session, :event => event) }
  subject { session }
  let(:rsvp) { FactoryGirl.create(:rsvp, :session => session, :user => user) }
  subject { rsvp }

  context 'is invalid' do

    it 'when it has a invalid factory' do
      expect(user).to be_valid
    end

    it "when it is without a access_token" do
      expect(user.access_token).not_to be_nil
    end

    it "when it is without a twitter_secret" do
      expect(user.twitter_secret).not_to be_nil
    end

    it "when it is without a uid" do
      expect(user.uid).not_to be_nil
    end

    it "when it is without a name" do
      expect(user.name).not_to be_nil
    end

    it "when it is without a provider" do
      expect(user.provider).not_to be_nil
    end

  end

  context '#events' do

    it 'should return events' do
      expect { user.events }.not_to raise_error
    end

  end

  context '#rsvps' do

    it 'should return rsvps' do
      expect { user.rsvps }.not_to raise_error
    end

  end

  context '#attending_sessions' do

    it 'should return sessions attending by the user' do
      expect { user.attending_sessions }.not_to raise_error
    end
  
  end

  context '#attending_events' do

    it 'should return events attending by the user' do
      expect { user.attending_events }.not_to raise_error
    end

  end
  
  context 'raises exception when called with' do

    it " #destroy" do
      expect { @user.destroy }.to raise_error
    end

    it "#delete" do
      expect { @user.delete }.to raise_error
    end

    it '.destroy_all' do
      expect { User.destroy_all }.to raise_error
    end

    it '.delete_all' do
      expect { User.delete_all }.to raise_error
    end

  end  

  context '.create_with_ominauth' do

    it 'should return user' do
      auth = { 'provider' => "twitter",
               'credentials' => { 'token' => "edeed", 'twitter_secret' => "twitter_secret" },
               'uid' => "uid",
               'info' => { 'urls' => { 'Twitter' => 'abc' }, 'name' => "dp" },
             }
      expect(User.create_with_omniauth(auth)).to be_an_instance_of(User)
    end

  end

  context '#attending?' do
    
    it 'should return true if attending session' do
      Rails.logger.debug user.attending?(session).inspect
      expect(user.attending?(session)).to be_true
    end

    it 'should return false if not attending session' do
      session = FactoryGirl.create(:session, :event => event)
      expect(user.attending?(session)).to be_false
    end

  end

end