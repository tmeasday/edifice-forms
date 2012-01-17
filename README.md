Unobtrusive Javascript Form Extensions for Rails 3
==================================================

edifice-forms the part of the [edifice project](https://github.com/tmeasday/edifice) which improves your experience with forms inside rails.

Note that it does not depend on edifice, although it complements it well.

Extending remote forms to handle errors
---------------------------------------

Rails 3 includes the excellent Unobtrusive JS, which allows us to define remote forms unobtrusively:

    <form data-remote="true">

This will result in the form submitting via AJAX, however there is no support for errors in the form. This is surprising as the convention for rails form errors is clearly defined; return a HTML status 422 (`:unprocessible_entity`). In fact this is what the `responds_with` responder will do (for non-AJAX requests):

    # Super-lean Rails controllers do it for me
    class UsersController
      def update
        respond_with @user = User.update(params[:user])
      end
    end

edifice-forms extends this convention to AJAX requests. Firstly, we augment rails to respond with a 422 on invalid AJAX updates. Secondly, we add a `data-form` attribute:

    <%= form_for @user, :remote => true, :html => {:'data-form' => 'show_errors'} do |f| %>

Now, when your users controller returns an error + an updated form with the errors highlighted, we'll automatically replace the form with the 'errored' version. Not a single line of Javascript required for such a common behaviour!

rails_form.js
-------------

What about if your form returns data in JSON? We've got you covered. In order for remote JSON forms to show errors, we've written a small jQuery plugin: `rails_form.js`. It is written to conform to the conventions laid down by actionpack. 

For instance, if you have, in your view:

    <form>
      <label for="user[name]"></label>
      <input name="user[name]" value="Tom"></input>
    </form>
    
You can call:

    $('form').rails_form('add_error', 'user[name]', 'needs a surname');

Which will result in:

    <form>
      <div class="field_with_errors">
        <label for="user[name]"></label>
      </div>
      <div class="formError">needs a surname</div>
      <div class="field_with_errors">
        <input name="user[name]" value="Tom"></input>
      </div>
    </form>

The error can be removed with:
    
    // FIXME -- this isn't how it's implemented right now
    $('form').rails_form('clear_error', 'user[name]');

We've also added a convention that rails seemed to leave out, if you prefer your errors to be co-located:

    <%= render_errors(f) >
    
Which will output something like:

    <ul class="errors">
      <li data-for="name">Name needs a surname</li>
    </ul>

Forms with `show_errors` set will detect such a structure and update it on AJAX errors.

Use at your discretion.

FormModel
---------

The final piece of the puzzle is perhaps the most useful. Suppose you have a form on your site which isn't backed by a model. A good example is a feedback form. The feedback 'model' doesn't need to persist, it simply needs to send an email when it successfully saves; but we would still like to have all the ActiveModel goodness (validations, callbacks, etc) of a real ActiveRecord model. Enter the FormModel:

    class Feedback < Edifice::Forms::FormModel
      attr_accessor :message
      attr_accessor :email

      # some simple validators
      validates :email, :presence => true, :format => {:with => /^.+@.+\..+$/}
      validates :message, :presence => true
      
      # if validations pass and we successfully save, go ahead and deliver the 
      # feedback email to us, so we can read it.
      def save
        SelfMailer.feedback(self).deliver
      end
    end

Looks a lot like a ActiveRecord model, doesn't it? We get to write our controllers in the same super skinny way:

    class FeedbacksController < ApplicationController
      def new
        respond_with @feedback = Feedback.new
      end
      
      def create
        respond_with @feedback = Feedback.create params[:feedback]
      end
    end

Don't worry, we can use the `@feedback` in our views just as we would with a real model:

    <%= form_for @feedback, :remote => true, 
          :html => {:'data-form' => 'show_errors'} do |f| %>
      <%= f.label :message, 'Your Feedback' %>
      <%= f.error_message_on :message %>
      <%= f.text_area :message, :placeholder => 'How can we help?' %>
    <% end %>

Simple, huh?

License
-------

Edifice is crafted by [Percolate Studio](http://percolatestudio.com) and released under the [MIT license](www.opensource.org/licenses/MIT)
