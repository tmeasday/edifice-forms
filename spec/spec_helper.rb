ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] = File.join(File.dirname(__FILE__), 'rails3.1')

require File.expand_path('config/environment', ENV['RAILS_ROOT'])

require 'rspec/rails'
require 'capybara/rails'

# some useful matchers for rails form stuff
RSpec::Matchers.define :have_error_on do |selector|
  match do |page|
    page.has_selector? ".field_with_errors \##{selector}"
  end
end

RSpec::Matchers.define :have_no_error_on do |selector|
  match do |page|
    page.has_no_selector? ".field_with_errors \##{selector}"
  end
end


RSpec::Matchers.define :have_rendered_error_on do |selector|
  match do |page|
    page.has_selector? ".errors li[data-for=#{selector}]"
  end
end
