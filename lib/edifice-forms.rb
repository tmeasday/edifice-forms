require 'edifice-forms/helper'
require 'edifice-forms/controller'
require 'edifice-forms/form_model'
require 'edifice-forms/responder'

module EdificeForms
  class Engine < Rails::Engine
  end
end

ActionView::Base.send :include, EdificeForms::Helper
ActionController::Base.send :include, EdificeForms::Controller