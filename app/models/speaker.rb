class Speaker < ActiveRecord::Base
  belongs_to :session
  
  has_attached_file :profile_picture, :styles => { :medium => "1000x400<", :thumb => "50x50>" }, :default_url => "/images/:style/rails.jpeg"
  validates :name, :presence => true
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/
  after_save :set_profile_picture

  private

    def set_profile_picture
      if self.profile_picture_file_name.nil?
        self.profile_picture = ::Client.user(self.twitter_handle).profile_image_url_https.to_s
        self.save
      end
      rescue Twitter::Error::Unauthorized
        self.profile_picture = nil
    end

end