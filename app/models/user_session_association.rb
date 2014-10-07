class UserSessionAssociation < ActiveRecord::Base
  #FIXME_AB: can we have a better name, I don't like asssocioation in the model name
  belongs_to :session
  belongs_to :user

  #FIXME_AB: we can live without following association, as discussed
  belongs_to :event
end
