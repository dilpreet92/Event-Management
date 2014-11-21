class Speaker < ActiveRecord::Base
  belongs_to :session
  validates :name, :presence => true
end