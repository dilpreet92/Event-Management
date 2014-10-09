class Rsvp < ActiveRecord::Base

  belongs_to :session
  belongs_to :user


  #FIXME_AB: add required indexes to all tables. You can use bullet gem to identify them.
end
