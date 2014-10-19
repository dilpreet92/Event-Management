require 'spec_helper' 
describe User do 
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
  it "is invalid without a access_token" do
    FactoryGirl.build(:user, access_token: nil).should_not be_valid
  end

  it "is invalid without a twitter_secret" do
    FactoryGirl.build(:user, twitter_secret: nil).should_not be_valid
  end 
  it "is invalid without a uid" do
    FactoryGirl.build(:user, uid: nil).should_not be_valid
  end
  it "is invalid without a name" do
    FactoryGirl.build(:user, name: nil).should_not be_valid
  end
  it "is invalid without a provider" do
    FactoryGirl.build(:user, provider: nil).should_not be_valid
  end
end