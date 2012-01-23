require File.dirname(__FILE__) + '/spec_helper'

describe 'rails_form library', :type => :request, :js => true do
  before(:each) do
    page.visit('/users/new')
  end
  
  it 'should set an error' do
    page.execute_script "jQuery('form').rails_form('add_error', 'user[name]', 'is wrong');"
    
    page.should have_error_on('user_name')
    page.should have_content('is wrong')
  end
  
  it 'should clear an error' do
    page.execute_script "jQuery('form').rails_form('add_error', 'user[name]', 'is wrong');"
    page.execute_script "jQuery('form').rails_form('clear_error', 'user[name]');"
    
    page.should have_no_error_on('user_name')
    page.should have_no_content('is wrong')
  end
  
  it 'should set multiple errors' do
    page.execute_script "jQuery('form').rails_form('set_errors', {'user[name]': ['is wrong'], 'user[description]': ['is funny']});"
    
    page.should have_error_on('user_name')
    page.should have_content('is wrong')
    page.should have_error_on('user_description')
    page.should have_content('is funny')
  end
  
  it 'should clear all errors' do
    page.execute_script "jQuery('form').rails_form('set_errors', {'user[name]': ['is wrong'], 'user[description]': ['is funny']});"
    page.execute_script "jQuery('form').rails_form('clear_errors');"
    
    page.should have_no_error_on('user_name')
    page.should have_no_content('is wrong')
    page.should have_no_error_on('user_description')
    page.should have_no_content('is funny')
  end
  
  it 'should find all submits' do
    page.evaluate_script("jQuery('form').rails_form('submits').length;").should ==(1)
  end
  
  it 'should find all fields' do
    page.evaluate_script("jQuery('form').rails_form('fields').length;").should ==(3)
  end
  
  it 'should find all fields with errors' do
    page.execute_script "jQuery('form').rails_form('add_error', 'user[name]', 'is wrong');"
    page.evaluate_script("jQuery('form').rails_form('error_fields').length;").should ==(1)
  end
  
  it 'should find the form error message' do
    page.execute_script "jQuery('form').rails_form('add_error', 'user[name]', 'is wrong');"
    page.evaluate_script("jQuery('form').rails_form('error_on', 'user[name]').text();").should ==('is wrong')
  end
  
  it 'should find the label for an input' do
    page.evaluate_script("jQuery('form').rails_form('label_for', 'user[name]').text();").should ==('Name')
  end
end