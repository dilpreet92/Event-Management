class User < ActiveRecord::Base

  #FIXME_AB: what would happen when I destroy a user. handle this case with all associations
  #FIXME_AB: As discussed in the meeting, I should not be able to destroy a user. So, overwrite destroy, delete, destroy_all and other related methods and raise exception 
  has_many :events, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :attending_sessions, through: :rsvps, source: :session
  has_many :attending_events, through: :attending_sessions, source: :event

  validates :name, presence: true
  validates :uid, :provider, presence: true

  # def get_attending_events
  #   attending_sessions.map(&:event_id).uniq
  # end

  def self.create_with_omniauth(auth)

    #FIXME_AB:  I personally don't prefer to use block with create
    create do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.handle = auth['info']['urls']['Twitter']
        user.name = auth['info']['name']
      end
    end
  end

end
