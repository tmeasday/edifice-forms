(function($) {
  var showErrorSelector = 'form[data-form*=show_errors]';
  
  $(showErrorSelector).live('ajax:error', function(event, request, status, error) {
    // CLIENT ERROR -- server-side validation failed. -- FIXME -should this be 422 only?
    if (request.status >= 400 && request.status < 500) { 
      // if data is html, we replace this content of the form with the content
      // of the form that we've just received back
      var contentType = request.getResponseHeader('Content-Type');
      if (/html/.test(contentType)) {
        // wrap in a div incase there are a bunch of floating elements, pull the form out
        var $new_form = $('<div>' + request.responseText + '</div>').find('#' + $(this).attr('id'));
        $(this).html($new_form.html());
        
      } else if (/json/.test(contentType)) {
        // we will be receiving an error object back, we can pass it straight into rails_form.js
        $(this).rails_form('set_errors', $.parseJSON(request.responseText));
      } else {
        throw "edifice-forms/show-errors: Don't know how to handle dataType " + request.dataType;
      }
    }
  });
}(jQuery));