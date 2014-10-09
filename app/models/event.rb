class Event < ActiveRecord::Base

  belongs_to :user
  
  has_many :sessions, dependent: :destroy
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validates :contact_number, numericality: { only_integer: true }
  validate :validate_date

  scope :enabled, -> { where(enable: true) }
  scope :order_by, -> (sort) { order(start_date: sort) }
  scope :upcoming, -> { where("end_date >= ?", Time.current) }
  scope :past, -> { where("end_date < ?", Time.current) }
  scope :search, -> (event) { where("name LIKE :event OR city LIKE :event OR country LIKE :event",
                            event: "%#{ event }%") }

  def get_attendes
    sessions.collect do |session|
      session.attendes
    end.flatten.uniq
  end

  def upcoming?
    end_date >= Time.current 
  end

  private
  def validate_date
    if start_date < Time.current || start_date >= end_date
      errors.add(:start_date, ' Should be less than end date and Should be a future date')
    end
  end

end
