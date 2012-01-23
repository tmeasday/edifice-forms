require File.dirname(__FILE__) + '/spec_helper'

shared_examples_for :form_that_shows_errors do
  it "should show errors when validation fails" do
    page.click_button('Submit')
    
    page.should have_error_on 'user_name'
  end
  
  it "should show errors when validation fails in .errors" do
    page.click_button('Submit')
    
    page.should have_rendered_error_on 'user_name'
  end
  
  it "not change when validation succeeds" do
    page.fill_in 'Name', :with => 'whatever'
    page.click_button('Submit')
    
    page.should have_no_error_on 'user_name'
  end
end

describe 'html forms with show_errors', :type => :request, :js => true do
  before(:each) do
    page.visit('/users/new?type=html&ajax=false')
  end
  
  it_behaves_like :form_that_shows_errors
end

describe 'json forms with show_errors', :type => :request, :js => true do
  before(:each) do
    page.visit('/users/new?type=json&ajax=false')
  end
  
  it_behaves_like :form_that_shows_errors
end

describe 'ajax html forms with show_errors', :type => :request, :js => true do
  before(:each) do
    page.visit('/users/new?type=html&ajax=true')
  end
  
  it_behaves_like :form_that_shows_errors
end

describe 'ajax json forms with show_errors', :type => :request, :js => true do
  before(:each) do
    page.visit('/users/new?type=json&ajax=true')
  end
  
  it_behaves_like :form_that_shows_errors
end
