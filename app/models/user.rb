class User < ActiveRecord::Base
  has_many :events
  has_many :user_event_associations
  has_many :attending_events, through: :user_event_associations, source: :event
  validates :name, presence: true

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.id = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end
end
