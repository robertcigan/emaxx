class Page < ActiveRecord::Base
  has_friendly_id :title, 
    :use_slug => true, 
    :approximate_ascii => true, 
    :max_length => 50, 
    :reserved_words => ["index", "new", "edit", "create", "page", "destroy", "update", "show"]

  validates :title, :presence => true
  attr_accessible :title, :content
end
