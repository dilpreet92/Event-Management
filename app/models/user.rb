class User < ActiveRecord::Base

  #FIXED: what would happen when I destroy a user. handle this case with all associations
  #FIXED: As discussed in the meeting, I should not be able to destroy a user. So, overwrite destroy, delete, destroy_all and other related methods and raise exception 
  has_many :events, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :attending_sessions, through: :rsvps, source: :session
  has_many :attending_events, through: :attending_sessions, source: :event

  validates :name, presence: true
  validates :uid, :provider, presence: true

  def self.create_with_omniauth(auth)
    #FIXED:  I personally don't prefer to use block with create
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
