module RailsUjsForm
  module Helper
    # not sure why there isn't something like this in rails
    #
    # render the errors on an object in a fairly standard way:
    #
    # <ul class="errors">
    #   <li data-for="name">Name cannot be blank</li>
    # </ul>
    def render_errors(builder)
      errors = builder.object.errors
      messages = errors.full_messages
      content_tag :ul, :class => :errors do
        output = ''
        errors.each_with_index do |error, i|
          output << content_tag(:li, :'data-for' => "#{builder.object_name}_#{error[0]}") { messages[i] }
        end
        output.html_safe
      end
    end
  end
end