class PhotosController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :page
  load_and_authorize_resource :photo, :through => :page

  
  # POST /photos
  # POST /photos.json
  def create
    @photo.save
    respond_with(@photo) do |format|
      # format.json do
      #         if @photo.errors.any?
      #           render :json => [ @photo.to_jq_upload ].to_json
      #         else 
      #           render :json => [ @photo.to_jq_upload.merge({ :error => "failure" }) ].to_json
      #         end
      #       end
      format.html do
        redirect_to edit_page_path(@page)
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_with(@photo) do |format|
      # format.json do
      #         render :json => true
      #       end
      format.html do
        redirect_to edit_page_path(@page)
      end
    end
  end
end
