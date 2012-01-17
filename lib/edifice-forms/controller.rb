module Edifice
  module Forms
    module Controller
      def self.included(controller)
        controller.class_eval do
          def self.responder
            Edifice::Forms::Responder
          end
        end
      end
    end
  end
end