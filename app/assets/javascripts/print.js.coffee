# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#print_building").change ->
      slug = $("#print_building option:selected").val()
      $("#print_printer").empty()
      $("#print_printer").append($("<option></option>").attr("value", printer).text(printer)) for printer in printers[slug]