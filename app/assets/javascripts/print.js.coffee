# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  if getParameterByName("success") == "true"
      _gaq.push(['_trackEvent', 'Printing', 'Print']);

  $("#print_building").change ->
      $("#print_printer").empty()
      slug = $("#print_building option:selected").val()
      $("#print_printer").empty()
      $("#print_printer").append($("<option></option>").attr("value", printer).text(printer)) for printer in printers[slug]