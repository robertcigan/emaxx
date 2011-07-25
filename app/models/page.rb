class Page < ActiveRecord::Base
  has_friendly_id :title, 
    :use_slug => true, 
    :approximate_ascii => true, 
    :max_length => 50, 
    :reserved_words => ["index", "new", "edit", "create", "page", "destroy", "update", "show"]

  validates :title, :presence => true
  attr_accessible :title, :content, :publish_at
  
  scope :published, lambda { where("publish_at <= ?", Time.zone.now).order("publish_at desc") }
  
  before_save :generate_html
  
  def generate_html
    if self.content_changed?
      markdown = Redcarpet.new(self.content)
      self.html_content = markdown.to_html
    end
  end
end
