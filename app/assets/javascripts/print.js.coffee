# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  printer = $("select#print_printer")
  building = $("select#print_building")

  format = (selection) ->
    status = gon.status[selection.id]
    image = if status then "<img class='status #{status}' />" else ""
    image + selection.text

  building.change (event) -> change_printers(event.delegateTarget.value)