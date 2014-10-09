class Event < ActiveRecord::Base
  #FIXME_AB: address should not be string, it should be text

  belongs_to :user
  
  has_many :sessions, dependent: :destroy

  #FIXME_AB: you should also rad about the patterns we can pass to paperclip styles. like we have > sign in following style, there are much more.
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  #FIXME_AB: we may need to convert contact number to string. Keep it as it is for now
  validates :contact_number, numericality: { only_integer: true }
  validate :validate_date

  scope :enabled, -> { where(enable: true) }
  #FIXME_AB: as discussed we don't need following order_by scope. In case we need then it should be:   scope :order_by_start_date, -> (sort = 'ASC') { order(start_date: sort) }
  scope :order_by, -> (sort) { order(start_date: sort) }

  #FIXME_AB: rename it to live_and_upcoming
  scope :upcoming, -> { where("end_date >= ?", Time.current) }
  scope :past, -> { where("end_date < ?", Time.current) }
  scope :search, -> (query) { where("name LIKE :query OR city LIKE :query OR country LIKE :query",
                            query: "%#{ query }%") }

  def get_attendes
    #FIXME_AB: we can do it through associations like we did from event. [90% sure]
    sessions.collect do |session|
      session.attendes
    end.flatten.uniq
  end

  #FIXME_AB: should be named as live_and_upcoming
  def upcoming?
    end_date >= Time.current 
  end

  def to_param
    "#{id}-#{name}"
  end

  private
  #FIXME_AB: low priority: think about a better name
  def validate_date
    #FIXME_AB: if start_date_unacceptable? or if start_date_invalid?
    if (start_date < Time.current) || (start_date >= end_date)
      errors.add(:start_date, ' Should be less than end date and Should be a future date')
    end
  end


  #FIXME_AB: When I am updating any event, we should check for session time too. It should not allow event to shrink beyond the session times

end
