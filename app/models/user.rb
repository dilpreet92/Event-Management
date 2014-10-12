class User < ActiveRecord::Base

  #FIXED: what would happen when I destroy a user. handle this case with all associations
  has_many :events, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :attending_sessions, through: :rsvps, source: :session
  has_many :attending_events, through: :attending_sessions, source: :event

  validates :name, presence: true
  validates :uid, :provider, presence: true
  #FIXED: you should also add validation on uid and provider

  #FIXED: remove get from the name user.events_attending
  # def get_attending_events
  #   #FIXME_AB: You don't need this method. All this can be done as user.attending_session_ids
  #   #FIXME_AB: has_many :attending_events, through: :attending_sessions, source: :event
  #   #FIXME_AB: Read about pluck method
  #   attending_sessions.map(&:event_id).uniq
  # end

  def self.create_with_omniauth(auth)

    #FIXED: I personally don't prefer to use block with create!
    create do |user|
      user.provider = auth['provider']
      #FIXED: id should be primary key and auto-generated, should not the twitter user id. If needed add this to uid
      user.uid = auth['uid']
      if auth['info']
        user.handle = auth['info']['urls']['Twitter']
        user.name = auth['info']['name']
      end
    end
  end

end
