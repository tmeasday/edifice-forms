module EdificeForms
  module Controller
    def self.included(controller)
      controller.class_eval do
        def self.responder
          EdificeForms::Responder
        end
      end
    end
  end
end