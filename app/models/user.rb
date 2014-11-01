class User < ActiveRecord::Base

  include Destroyable

  before_save :manipulate_related_events,if: :events
  
  has_many :events
  has_many :rsvps, dependent: :destroy
  has_many :attending_sessions, through: :rsvps, source: :session
  has_many :attending_events, through: :attending_sessions, source: :event

  validates :name, presence: true
  validates :uid, :handle, :provider, :access_token, :twitter_secret, presence: true

  def self.create_with_omniauth(auth)
    create(provider: auth['provider'], uid: auth['uid'], handle: auth['info']['urls']['Twitter'], 
           name: auth['info']['name'], access_token: auth['credentials']['token'], 
           twitter_secret: auth['credentials']['secret'], twitter_name: auth['info']['nickname'])
  end

  def my_created_past_events
    events.past.order_by_start_date(:desc)
  end

  def my_created_upcoming_events
    events.live_and_upcoming.order_by_start_date(:asc)
  end

  def my_past_attended_events
    attending_events.enabled.past.order_by_start_date(:desc)
  end

  def my_upcoming_attending_events
    attending_events.enabled.live_and_upcoming.order_by_start_date(:asc)
  end

  def attending?(session)
    attending_sessions.exists?(session)
  end

  private

    def manipulate_related_events
      if enabled?
        events.update_all(:enable => true)
      else
        events.update_all(:enable => false)
      end
    end

end
