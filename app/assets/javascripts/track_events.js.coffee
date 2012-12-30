$ ->
  $("#sql").submit ->
    _gaq.push ["_trackEvent", "Queries", "Submitted", $("#sql_query").val()]
