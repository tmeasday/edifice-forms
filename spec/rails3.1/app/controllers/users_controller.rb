class UsersController < ApplicationController
  respond_to :html, :json
  
  def new
    @type = params[:type] || 'html'
    @ajax = params[:ajax] || false
    
    respond_with @user = User.new
  end
  
  def create
    respond_with @user = User.create(params[:user])
  end
  
  def index
    head :ok
  end
end