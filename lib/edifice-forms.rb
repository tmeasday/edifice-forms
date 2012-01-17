require 'edifice-forms/helper'

module EdificeForms
  class Engine < Rails::Engine
  end
end

ActionView::Base.send :include, EdificeForms::Helper
