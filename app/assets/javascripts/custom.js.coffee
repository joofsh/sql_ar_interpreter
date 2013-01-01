
$ ->
  sql_box = $("textarea#sql_query")
  sql_box.keydown (e) ->
    if event.keyCode == 13
      e.preventDefault()

  sql_box.keyup ->
    if event.keyCode == 13
      $("input.button").trigger('click')
      return false
