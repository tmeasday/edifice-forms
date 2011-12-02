require 'rails-ujs-form/helper'

module RailsUjsForm
  class Engine < Rails::Engine
  end
end

ActionView::Base.send :include, RailsUjsForm::Helper
