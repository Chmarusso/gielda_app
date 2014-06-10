# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
policzStope = ->
  $("#myForm2").submit (e) ->
    e.preventDefault()
    $.ajax
      type: "GET"
      url: "/companies/calculator"
      data:
        companyname: $("#companyname").val()
        start_date: $("#start_date").val()
        end_date: $("#end_date").val()

      dataType: "json"
      beforeSend: ->
        $("#loading-icon-wrapper").html "<img src='/img/ajax-loader.gif'>"
      success: (data) ->
        $("#loading-icon-wrapper").html ""
        if data > 0
          div_class = "alert-success"
        else
          div_class = "alert-danger"
        $('#results-benchmark').html "<div class='alert "+div_class+"'><b>Stopa zwrotu:</b> "+data+"</div>"
        return
    return
  return

policzPunkty = ->
  sumaPkt = 0
  i = 1
  while i < 8
    odpowiedz = parseInt($("input[name='pyt" + i + "']:checked").val())
    sumaPkt += odpowiedz  unless isNaN(odpowiedz)
    i++
  sumaPkt

dataPickers = ->
  $('#datetimepicker1, #datetimepicker2').datetimepicker()

getAutocomplete = ->
  $("#companyname").autocomplete
    source: "/companies/search"
    minLength: 2
    select: (event, ui) ->
      $("#companyname").val ui.item.value
      return

sprawdzProfil = ->
  $("#myForm").submit (e) ->
    e.preventDefault()
    punkty = policzPunkty()
    if punkty >= 3
      msg="Jesteś inwestorem z awersją do ryzyka"
    else if punkty < 3 and punkty > -3
      msg="Jesteś inwestorem z umiarkowanym podejściem do ryzyka"
    else if punkty <= -3
      msg="Jesteś inwestorem ze skłonnością do ryzyka"
    else
      msg="coś poszło nie tak"
    $("#myForm").fadeOut "slow"
    $("#quizmsg").html "<p class='bg-info'>"+msg+"</p>"
    $.scrollTo("#top-body")
    return
  return

$(document).ready ->
  sprawdzProfil()
  dataPickers()
  getAutocomplete()
  policzStope()
  return

$(document).off("page:always").on "page:always", (event, $target, status, url, data) ->
  sprawdzProfil()
  dataPickers()
  getAutocomplete()
  policzStope()
  return    

