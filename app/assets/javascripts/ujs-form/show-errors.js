(function($) {
  var showErrorSelector = 'form[data-show-errors]';
  
  $(showErrorSelector).live('ajax:error', function(event, request, status, error) {
    console.log(request);
    // CLIENT ERROR -- server-side validation failed. -- FIXME -should this be 422 only?
    if (request.status >= 400 && request.status < 500) { 
      // if data is html, we replace this content of the form with the content
      // of the form that we've just received back
      var contentType = request.getResponseHeader('Content-Type');
      if (contentType =~ /html/) {
        // wrap in a div incase there are a bunch of floating elements, pull the form out
        var $new_form = $('<div>' + request.responseText + '</div>').find('#' + $(this).attr('id'));
        $(this).html($new_form.html());
        
      } else if (contentType =~ /json/) {
        // we will be receiving an error object back, we can pass it straight into rails_form.js
        this.rails_form('set_errors', $.parseJSON(request.responseText));
      } else {
        throw "ujs-form/show-errors: Don't know how to handle dataType " + request.dataType;
      }
    }
  });
}(jQuery));