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
// TODO: verify compatiblity of turbolinks with bootstrap
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require bootstrap
//= require bootstrap-datepicker
//= require jquery.tablesorter
//= require turbolinks
//= require thot
//= require barcode_scanner
//= require book_merger
//= require librarian
//= require inventory
//= require inactivity_monitor

function on_ready() {
  thot.ready();
}

$(document).ready(on_ready);
$(document).on('page:load', on_ready);

// function NebisLogout(t) {
//   console.debug("NebisLogout constructor with t="+t);
//   var _this = this;
//   this.dt = t*1000;
//   this.timeoutLabel = $('#nebis_timeout');
//   this.tickInterval = 0;
//   this.timeLeft = function() {
//     return this.t0-jQuery.now();
//   };
//   this.resetCountdown = function() {
//     this.t0 = jQuery.now() + this.dt;
//     setTimeout(function(){_this.alert();}, this.timeLeft()-5000);
//     console.debug("Setting for logout in " + this.secondsToGo() + " seconds");
//   }
//   this.secondsToGo = function() {
//     return Math.round(this.timeLeft()/1000);
//   };
//   this.tick = function() {
//     if (this.secondsToGo()>=0) {
//       this.timeoutLabel.text(this.secondsToGo());
//     } else {
//       clearInterval(this.tickInterval);
//       $('#nebis_timeout_dialog').modal('hide');
//     }
//   };
//   this.alert = function() {
//     // var _this = this;
//     this.timeoutLabel.text(this.secondsToGo());
//     this.tickInterval = setInterval(function(){_this.tick();}, 1000);
//     $('#nebis_timeout_dialog').modal('show');
//   };
//   this.resetCountdown();
//   $('#reset_timer_link').bind('ajax:success', function(evt, data) {_this.resetCountdown(); $('#nebis_timeout_dialog').modal('hide');});
//   $('#reset_timer_link').bind('ajax:error', function(evt, data) {
//       resp=JSON.parse(data.responseText);
//       $('#nebis_timeout_dialog').modal('hide');
//       console.debug("resp="+resp);
//       console.debug("resp.alert="+resp.alert+"    resp[alert]="+resp["alert"]);
//       add_alert("error", resp.alert);
//     });
// }

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
