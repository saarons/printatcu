# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
    change_printers = (slug) ->
        $("#print_printer").empty()
        $("#print_printer").append($("<option></option>").attr("value", printer).text(printer)) for printer in printers[slug]
        
    $("#print_building").change ->
        change_printers($("#print_building option:selected").val())
        
    if !defaults && $.cookie("printer") && $.cookie("building")
        $("#print_building option[value=\"#{$.cookie("building")}\"]").get(0).selected = true
        $("#print_building").change();
        $("#print_printer option[value=\"#{$.cookie("printer")}\"]").get(0).selected = true
        
    $.fool({wonky:true, flash: true, hiddenVideos: true})