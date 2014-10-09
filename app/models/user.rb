class User < ActiveRecord::Base

  #FIXME_AB: what would happen when I destroy a user. handle this case with all associations
  has_many :events
  has_many :rsvps
  has_many :attending_sessions, through: :rsvps, source: :session


  validates :name, presence: true
  #FIXME_AB: you should also add validation on uid and provider

  #FIXME_AB: remove get from the name user.events_attending
  def get_attending_events
    #FIXME_AB: You don't need this method. All this can be done as user.attending_session_ids
    #FIXME_AB: has_many :attending_events, through: :attending_sessions, source: :event
    #FIXME_AB: Read about pluck method
    attending_sessions.map(&:event_id).uniq
  end

  def self.create_with_omniauth(auth)

    #FIXME_AB: I personally don't prefer to use block with create!
    create! do |user|
      user.provider = auth['provider']
      #FIXME_AB: id should be primary key and auto-generated, should not the twitter user id. If needed add this to uid
      user.id = auth['uid']
      if auth['info']
        user.handle = auth['info']['urls']['Twitter']
        user.name = auth['info']['name']
      end
    end
  end

end
