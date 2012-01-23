require File.dirname(__FILE__) + '/spec_helper'

describe UsersController do
  include RSpec::Rails::ControllerExampleGroup
  
  it 'should return new' do
    get 'new'
    
    response.should render_template(:new)
  end
  
  it 'should behave correctly on validation errors' do
    post 'create', :user => {:name => ''}
    
    response.should render_template(:new)
  end
  
  it 'should update successfully' do
    User.should_receive(:model_saved)
    
    post 'create', :user => {:name => 'a lengthy name'}
    
    response.should redirect_to(users_path)
  end
end