/**
 * A small jQuery plugin to add 'rails-aware' form functionality.
 *
 * Basically, this understands the 'standard' rails way of structuring forms
 * and makes some functions available to manipulate that.
 */
(function($) {
$.fn.rails_form = function(method) {
  if (methods[method]) {
    return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
  } else {
    $.error('Method ' +  method + ' does not exist on rails_form');
  }
};

// in these 'this' is the $form
var methods = {
  fields: function() {
    return this.find('input, textarea, select');
  },
  
  error_fields: function() {
    var $form = this;
    return this.rails_form('fields').filter(function() {
      return $form.rails_form('has_error', $(this));
    });
  },
  
  submits: function() {
    return this.find('input[type=submit], button[type=submit]');
  },
  
  label_for: function($field) {
    return this.find('label[for=' + $field.attr('id') + ']');
  },
  
  error_on: function($field) {
    return this.rails_form('label_for', $field).parents('.field_with_errors').next('.formError');
  },
  
  has_error: function($field) {
    return $field.parent('.field_with_errors').length > 0;
  },
  
  clear_error: function($field) {
    var id = $field.attr('id');
    if (this.rails_form('has_error', $field)) { $field.unwrap() }
    
    this.find('.field_with_errors label[for=' + id + ']')
      .unwrap()
      .next('.formError').remove();
    
    return this;
  },
  
  add_error: function($field, error) {
    var id = $field.attr('id');
    $field.wrap('<div class="field_with_errors">');
    this.find('label[for=' + id + ']')
      .after('<div class="formError">' + error + '</div>')
      .wrap('<div class="field_with_errors">');
    
    return this;
  },
  
  // display standard errors as returned by JSON
  set_errors: function(errors) {
    for (var name in errors) {
      this.rails_form('add_error', this.fields().filter('[name*=' + name + ']'), errors[name][0]);
    }
    return this;
  }
};

}(jQuery));