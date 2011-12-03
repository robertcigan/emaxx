class PhotosController < ApplicationController
  respond_to :js
  before_filter :authenticate_user!
  load_and_authorize_resource :page
  load_and_authorize_resource :photo, :through => :page

  
  # POST /photos
  # POST /photos.json
  def create
    @photo.save
    respond_with(@page, @photo)
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_with(@page, @photo)
  end
end
