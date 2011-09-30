class Photo < ActiveRecord::Base
  belongs_to :page
  mount_uploader :file, ImageUploader
  
  validates :file, :presence => true
  
  attr_protected :page_id
  
  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "thumbnail_url" => file.small.url,
      "delete_url" => page_photo_path(:page_id => self.page, :id => id),
      "delete_type" => "DELETE" 
    }
  end
end
