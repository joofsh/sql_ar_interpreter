
$ ->
  sql_box = $("textarea#sql_query")
  sql_box.keydown (e) ->
    if event.keyCode == 13
      e.preventDefault()
      $("input.button").trigger('click')
