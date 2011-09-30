require 'spec_helper'

describe Photo do
  before do
    @photo = Factory(:photo)
  end

  describe 'validation' do
    describe 'of photo' do
      it 'requires to be present' do
        photo = Factory.build(:photo, :file => nil)
        photo.should have(1).error_on(:file)
      end
    end
  end

  describe 'mass assigment protection' do
    it 'allows photo' do
      expect { @photo.attributes = { :file => File.open(File.join(Rails.root, 'spec', 'files', 'test_image.png')) } }.to change{ @photo.file.url }
    end
  
    it 'does not allow page_id' do      
      expect { @photo.attributes = { :page_id => 999 } }.to_not change{ @photo.page_id }
    end
  end
  
  describe 'photo uploader' do
    it 'returns url' do
      @photo.file.url.should be_present
    end
    
    it 'returns file path' do
      @photo.file.current_path.should be_present
    end
    
    it ' returns identifier' do
      @photo.file_identifier.should be_present
    end
  end
end