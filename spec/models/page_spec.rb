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
    
    it 'does not allow cached_slug' do
      @page.attributes = { :cached_slug => 'changed' }
      expect { @page.reload }.to_not change{ @page.cached_slug }
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
end
