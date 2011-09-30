class Page < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_friendly_id :title, 
    :use_slug => true, 
    :approximate_ascii => true, 
    :max_length => 50, 
    :reserved_words => ["index", "new", "edit", "create", "page", "destroy", "update", "show"]
    
  has_many :photos, :dependent => :destroy

  validates :title, :presence => true
  attr_accessible :title, :content, :publish_at, :tag_list
  
  scope :published, lambda { where("publish_at <= ?", Time.zone.now) }
  scope :by_date, order("publish_at DESC") 
  
  before_save :generate_html, :generate_preview
  
  def generate_html
    if self.content_changed?
      markdown = Redcarpet.new(self.content)
      self.html_content = markdown.to_html
    end
  end
  
  def generate_preview
    if self.html_content_changed?
      self.preview = HTML_Truncator.truncate(self.html_content, 50)
    end
  end
end
