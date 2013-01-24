// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require bootstrap
//= require_tree .


// -----------------------------------------------------------------------------
// http://www.mcbsys.com/techblog/2012/10/convert-a-select-drop-down-box-to-an-autocomplete-in-rails/
// Automatically put focus on first item in drop-down list
// $('input[data-autocomplete]').autocomplete({ autoFocus: true });

// // Bind a new function to the autocomplete change event.  If
// // the "base" rails3-jquery-autocomplete also has a change event,
// // that code will execute as well.
// $('input[data-autocomplete]').bind('autocompletechange', function(event, ui) {
//   // rails3-jquery-autocomplete fills in ui.item with selected
//   // value, or sets it to null if no value selected.
//   if(!ui.item) {            // if nothing selected
//     $(this).val('');        // clear this field's value
//     clearDataValues(this);  // clear values in "id" and "update_elements" fields
//   }
// });

// function clearDataValues(autocompleteField) {
//   if ($(autocompleteField).attr('data-id-element')) {      // data-id-element found
//     $($(autocompleteField).attr('data-id-element')).val('');
//   }
//   if ($(autocompleteField).attr('data-update-elements')) { // data-update-elements found
//     $.each( $(autocompleteField).data('update-elements'),function(k, v) {
//       // alert('key='+ k + ' value=' + v);
//       $(v).val('');
//     })
//   }
// };
// -----------------------------------------------------------------------------
