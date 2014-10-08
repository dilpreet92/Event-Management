class User < ActiveRecord::Base

  has_many :events
  has_many :rsvps
  has_many :attending_sessions, through: :rsvps, source: :session

  validates :name, presence: true

  def get_attending_events
    attending_sessions.collect do |session|
      session.event_id
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.id = auth['uid']
      if auth['info']
        user.handle = auth['info']['urls']['Twitter']
        user.name = auth['info']['name']
      end
    end
  end

end
