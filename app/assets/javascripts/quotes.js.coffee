$(document).ready ->
    window.wiselinks = new Wiselinks()

$(document).off("page:loading").on "page:loading", (event, $target, render, url) ->
  $("#loading-icon-wrapper").html "<img src='/img/ajax-loader.gif'>"
  return

$(document).off("page:done").on "page:done", (event, $target, status, url, data) ->
  $("#loading-icon-wrapper").html ""
  return    