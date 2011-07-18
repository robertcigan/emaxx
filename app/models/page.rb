class Page < ActiveRecord::Base
  validates :title, :presence => true
  
  attr_accessible :title, :content
end
