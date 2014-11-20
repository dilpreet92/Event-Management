require 'spec_helper'

describe User do

  let!(:user) { FactoryGirl.build :user }
  let!(:event) { FactoryGirl.build(:event, :user => user) }
  let!(:session) { FactoryGirl.build(:session, :event => event) }
  let!(:rsvp) { FactoryGirl.build(:rsvp, :session => session, :user => user) }

  describe 'validations' do
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

  end

  describe '#associations' do
    
    it { expect(user).to have_many(:events) }
    it { expect(user).to have_many(:rsvps) }
    it { expect(user).to have_many(:attending_sessions).through(:rsvps).source(:session) }
    it { expect(user).to have_many(:attending_events).through(:attending_sessions).source(:event) }

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

  describe '.class_methods' do

    describe '.create_with_ominauth' do
      context 'when user successfully created' do
        it 'should return user' do
          auth = { 'provider' => "twitter",
                   'credentials' => { 'token' => "edeesasd", 'secret' => "twitterdasda" },
                   'uid' => "qeweqw",
                   'info' => { 'urls' => { 'Twitter' => 'abc' }, 'name' => "dp", 'nickname' => 'sd' },
                 }
          expect(User.create_with_omniauth(auth)).to be_an_instance_of(User)
        end
      end

      context 'when user not created' do
        it 'should return false' do
          auth = { 'provider' => "twitter",
                   'credentials' => { 'token' => "edeesasd", 'secret' => "twitterdasda" },
                   'uid' => "qeweqw",
                   'info' => { 'urls' => { 'Twitter' => 'abc' }, 'name' => "dp", 'nickname' => nil },
                 }
          expect(User.create_with_omniauth(auth)).to be_false
        end
      end

    end

  end

  describe '#instance_methods' do

    context '#attending?' do
      
      it 'should return true if attending session' do
        rsvp.save
        expect(user.attending?(session)).to be_true
      end

      it 'should return false if not attending session' do
        expect(user.attending?(session)).to be_false
      end

    end

    context '#my_created_past_events' do

      it 'should return my past created events' do
        event.save
        event.update_attribute(:end_date, Time.current - 1.day )
        expect(user.created_past_events).to include(event)
      end

    end

    context '#my_created_upcoming_events' do

      it 'should return my upcoming created events' do
        event.save
        expect(user.created_upcoming_events).to include(event)
      end

    end

    context '#my_past_attended_events' do

      before do
        event.update_attribute(:end_date, Time.current - 1.day )
        user.save
        session.save(validate: false)
        rsvp.save
      end

      it 'should return my past attended events' do
        expect(user.past_attended_events).to include(event)
      end

    end

    context '#my_upcoming_attending_events' do

      it 'should return my upcoming attending events' do
        rsvp.save
        expect(user.upcoming_attending_events).to include(event)
      end

    end

  end

end