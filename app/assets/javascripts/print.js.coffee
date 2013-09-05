# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  printer = $("#print_printer")
  building = $("#print_building")

  format = (selection) ->
    status = gon.status[selection.id]
    image = if status then "<img class='status #{status}' />" else ""
    image + selection.text

  printer.select2
    width: "off"
    formatResult: format
    formatSelection: format
    minimumResultsForSearch: NaN

  building.select2
    width: "off"

  change_printers = (slug) ->
    printer.empty()
    printer.append($("<option></option>").attr("value", p).text(p)) for p in gon.printers[slug]
    printer.select2("val", gon.printers[slug][0])
        
  building.change (event) -> change_printers(event.val)
        
  # if !defaults && (p = $.cookie("printer")) && (b = $.cookie("building"))
  #   building.select2("val", b)
  #   change_printers(b)
  #   printer.select2("val", p)