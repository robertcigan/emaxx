require 'spec_helper'
require 'carrierwave/test/matchers'

describe 'ImageUploader' do
  include CarrierWave::Test::Matchers

  before do
    @photo = Factory(:photo)
    ImageUploader.enable_processing = true
    @uploader = ImageUploader.new(@photo, :file)
    @uploader.store!(File.open(File.join(Rails.root, 'spec', 'files', 'test_image.jpg')))
  end

  context 'resizes to fill' do
    it "should scale down and fit within 1024 by 1024 pixels" do
      @uploader.small.should be_no_larger_than(200, 200)
    end
  end

  context 'creates thumbnail' do
    it "should scale down and fit within 96 by 96 pixels" do
      @uploader.small.should be_no_larger_than(96, 96)
    end
  end

  it "should make the image readable to all and not executable" do
    @uploader.should have_permissions(0644)
  end
end