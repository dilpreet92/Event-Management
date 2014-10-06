class UserSessionAssociation < ActiveRecord::Base
  belongs_to :session
  belongs_to :user
  belongs_to :event
end
