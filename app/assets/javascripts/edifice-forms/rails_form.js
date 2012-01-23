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
    return this.find('input:not([type=hidden]):not([type=submit]), textarea, select');
  },
  
  field: function(name_or_field) {
    if (name_or_field instanceof $) {
      return name_or_field;
    } else {
      return this.rails_form('fields').filter('[name*=' + $.escape(name_or_field) + ']');
    }
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
  
  label_for: function(name_or_field) {
    var $field = this.rails_form('field', name_or_field);
    return this.find('label[for=' + $field.attr('id') + ']');
  },
  
  error_on: function(name_or_field) {
    return this.rails_form('label_for', name_or_field).parents('.field_with_errors').next('.formError');
  },
  
  has_error: function(name_or_field) {
    var $field = this.rails_form('field', name_or_field);
    return $field.parent('.field_with_errors').length > 0;
  },
  
  clear_errors: function() {
    var $form = this;
    this.rails_form('fields').each(function() {
      $form.rails_form('clear_error', $(this));
    });
    
    // clear base errors too
    this.find('.errors').html('');
  },
  
  clear_error: function(name_or_field) {
    var $field = this.rails_form('field', name_or_field);
    var id = $field.attr('id');
    if (this.rails_form('has_error', $field)) { $field.unwrap() }
    
    this.find('.field_with_errors label[for=' + id + ']')
      .unwrap()
      .next('.formError').remove();
    
    // remove from a .errors ul
    this.find('.errors [data-for=' + id + ']').remove();
    
    return this;
  },
  
  // display standard errors as returned by JSON
  set_errors: function(errors) {
    this.rails_form('clear_errors');
    for (var name in errors) {
      for (var i in errors[name]) {
        this.rails_form('add_error', name, errors[name][i]);
      }
    }
    return this;
  },
  
  add_error: function(name_or_field, error) {
    var $field = this.rails_form('field', name_or_field);
    $field.filter('.field_with_errors > *').unwrap();
    $field.wrap('<div class="field_with_errors">');
    
    // if there is a field, and it has a label, show the error after it
    if ($field.length) {
      var id = $field.attr('id');
      var $label = this.rails_form('label_for', $field);
      var $error = $label.parent().next('.formError');
      
      if ($error.length) {
        $error.text(function(i, text) {
          return text + ', ' + error;
        });
      } else {
        $label.after('<div class="formError">' + error + '</div>')
          .wrap('<div class="field_with_errors">');
      }
    }
    
    // if there is an .errors list, show the error there
    var $errors = this.find('ul.errors');
    if ($errors.length) {
      // turns bindle[0][name] -> name etc
      var name = $field.attr('name').replace(/^.*\[(.*)\]$/, '$1');
      var message = name.charAt(0).toUpperCase() + name.substring(1).replace('_', ' ') + 
        ' ' + error;
      
      var $li = $('<li>' + message + '</li>');
      
      if ($field.length) {
        $li.attr('data-for', $field.attr('id'));
      }
      
      $errors.append($li);
    }
    
    return this;
  }
};

}(jQuery));