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
//= require jquery.ui.selectable
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-affix
//= require jquery.tablesorter
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

// TODO: re-enable autocomplete when a rails4 compatible version is out
//--------------------------- = require autocomplete-rails
