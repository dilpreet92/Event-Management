class User < ActiveRecord::Base

  include Destroyable

  has_many :events
  has_many :rsvps
  has_many :attending_sessions, -> { where('sessions.enable = true') }, through: :rsvps, source: :session
  has_many :attending_events, -> { distinct }, through: :attending_sessions, source: :event

  validates :name, :uid, :provider, :access_token, :twitter_secret, :twitter_name, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

  def self.create_with_omniauth(auth)
    create!(provider: auth['provider'], uid: auth['uid'], name: auth['info']['name'], 
           access_token: auth['credentials']['token'], twitter_secret: auth['credentials']['secret'], 
           twitter_name: auth['info']['nickname'])
    rescue ActiveRecord::RecordInvalid
      false
  end

  def created_past_events
    events.past
  end

  def created_upcoming_events
    events.live_or_upcoming
  end

  def past_attended_events
    attending_events.enabled.past
  end

  def upcoming_attending_events
    attending_events.enabled.live_or_upcoming
  end

  def attending?(session)
    attending_sessions.exists?(session)
  end

end
