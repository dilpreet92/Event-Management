class User < ActiveRecord::Base

  before_save :manipulate_related_events,if: :events
  
  has_many :events, dependent: :destroy
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

  def manipulate_related_events
    if enabled?
      events.update_all(:enable => true)
    else
      events.update_all(:enable => false)
    end
  end

  def attending?(session)
    attending_sessions.exists?(session)
  end

  def destroy
    raise 'User cannot be deleted'
  end

  def delete
    raise 'User cannot be deleted'
  end

  def self.destroy_all
    raise 'User cannot be deleted'
  end

  def self.delete_all
    raise 'User cannot be deleted'
  end

end
