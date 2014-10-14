class User < ActiveRecord::Base

  has_many :events, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :attending_sessions, through: :rsvps, source: :session
  has_many :attending_events, through: :attending_sessions, source: :event

  validates :name, presence: true
  validates :uid, :provider, presence: true

  def self.create_with_omniauth(auth)
    create(provider: auth['provider'], uid: auth['uid'], 
           handle: auth['info']['urls']['Twitter'], name: auth['info']['name'])
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
