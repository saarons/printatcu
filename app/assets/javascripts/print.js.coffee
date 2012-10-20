# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
    printer = $("#print_printer")
    building = $("#print_building")

    format = (selection) ->
        status = defcon[selection.id]
        "<img class=\"status #{status}\" /> #{selection.text}"

    printer.select2
        width: "off"
        formatResult: format
        formatSelection: format
        minimumResultsForSearch: NaN
    building.select2
        width: "off"

    change_printers = (slug) ->
        printer.empty()
        printer.append($("<option></option>").attr("value", p).text(p)) for p in printers[slug]
        printer.select2("val", printers[slug][0])
        
    building.change (event) -> change_printers(event.val)
        
    if !defaults && (p = $.cookie("printer")) && (b = $.cookie("building"))
        building.select2("val", b)
        change_printers(b)
        printer.select2("val", p)