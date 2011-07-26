require 'spec_helper'

describe Page do
  before do
    @page = Factory(:page)
  end
  
  describe 'validation' do
    describe 'of title' do
      it 'requires to be present' do
        page = Factory.build(:page, :title => nil)
        page.should have(1).error_on(:title)
      end
    end
  end
  
  describe 'mass assigment protection' do
    it 'allows title' do
      @page.attributes = { :title => 'changed' }
      expect { @page.reload }.to change{ @page.title }
    end
    
    it 'allows content' do
      @page.attributes = { :content => 'changed' }
      expect { @page.reload }.to change{ @page.content }
    end
    
    it 'does not allow html_content' do
      @page.attributes = { :html_content => 'changed' }
      expect { @page.reload }.to_not change{ @page.html_content }
    end
    
    it 'allows publish_date' do
      @page.attributes = { :publish_at => '2011-05-01 10:00:00' }
      expect { @page.reload }.to change{ @page.publish_at }
    end
    
    it 'does not allow cached_slug' do
      @page.attributes = { :cached_slug => 'changed' }
      expect { @page.reload }.to_not change{ @page.cached_slug }
    end
    
    it 'allows tag_list' do
      @page.attributes = { :tag_list => 'changed' }
      expect { @page.reload }.to change{ @page.tag_list }
    end
  end
  
  describe '#to_param' do
    it 'returns permalink' do
      @page.to_param.should eq('great-news')
    end
    
    it 'is regenerated if title is changed' do
      expect { @page.update_attributes(:title => 'New title') }.to change{ @page.reload.to_param }
    end
  end
  
  describe '#published' do
    Factory(:page, :title => 'Published', :publish_at => Time.zone.now - 10.days)
    Factory(:page, :title => 'Published', :publish_at => Time.zone.now + 10.days)
    it 'return only published page' do
      Page.published.count.should eq(1)
    end  
  end
  
  describe '#by_date' do
    it 'return only published page' do
      Page.delete_all
      page1 = Factory(:page, :title => 'Published1', :publish_at => Time.zone.now - 2.years)
      page2 = Factory(:page, :title => 'Published2', :publish_at => Time.zone.now - 1.year)
      Page.by_date.first.should eq(page2)
      Page.by_date.last.should eq(page1)
    end  
  end
  
  describe '#generate_html' do
    it 'is created from content' do
      @page.content = 'New content'
      expect{ @page.generate_html }.to change{ @page.html_content }.to("<p>New content</p>\n")
    end
    
    it 'is called before each save' do
      expect{ @page.update_attribute(:content, 'New content') }.to change{ @page.html_content }.to("<p>New content</p>\n")
    end
  end
end