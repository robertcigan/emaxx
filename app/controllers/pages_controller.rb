class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource 
  
  # GET /pages
  def index
    @tags = Page.tag_counts_on(:tags)
    if params[:tag]
      @pages = @pages.tagged_with(params[:tag])
    end
    @pages = @pages.page(params[:page])
    respond_with(@pages)
  end

  # GET /pages/1
  def show
    respond_with(@page)
  end
  
  # GET /pages/new
  def new
    respond_with(@page)
  end
  
  # POST /pages
  def create
    @page.save
    respond_with(@page)
  end

  # GET /pages/1/edit
  def edit
    respond_with(@page)
  end

  # PUT /pages/1
  def update
    @page.update_attributes(params[:page])
    respond_with(@page)
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
    respond_with(@page)
  end
end
