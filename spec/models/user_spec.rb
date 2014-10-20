require 'spec_helper'

describe User do

context 'with particular identity' do

  before :each do
    @user = FactoryGirl.create(:user)
  end

  it "has a valid factory" do
    @user.should be_valid
  end

  it "is invalid without a access_token" do
    @user.access_token.should_not == nil
  end

  it "is invalid without a twitter_secret" do
    @user.twitter_secret.should_not == nil
  end

  it "is invalid without a uid" do
    @user.uid.should_not == nil
  end

  it "is invalid without a name" do
    @user.name.should_not == nil
  end

  it "is invalid without a provider" do
    @user.provider.should_not == nil
  end

  it "cannot be destroyed" do
    expect { @user.destroy }.to raise_error
  end

  it "cannot be deleted" do
    expect { @user.delete }.to raise_error
  end
end  

  it 'Cannot be destroyed' do
    expect { User.destroy_all }.to raise_error
  end

  it 'cannot be deleted' do
    expect { User.delete_all }.to raise_error
  end

end