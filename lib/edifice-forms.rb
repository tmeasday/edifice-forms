require 'edifice-forms/helper'
require 'edifice-forms/controller'
require 'edifice-forms/form_model'
require 'edifice-forms/responder'

module Edifice
  module Forms
    class Engine < Rails::Engine
    end
  end
end

ActionView::Base.send :include, Edifice::Forms::Helper
ActionController::Base.send :include, Edifice::Forms::Controller