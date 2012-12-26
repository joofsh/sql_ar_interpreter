$ ->
  $("#sql").submit ->
    _gaq.push ["Queries", "Submit", $("#sql_query").val()]
