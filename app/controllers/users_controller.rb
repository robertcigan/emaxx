class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  
  # GET /users
  def index
    respond_with(@users)
  end

  # GET /users/1
  def show
    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    respond_with(@user)
  end

  # PUT /users/1
  def update
    @user.update_attributes(params[:user])
    respond_with(@user)
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_with(@user)
  end
end
