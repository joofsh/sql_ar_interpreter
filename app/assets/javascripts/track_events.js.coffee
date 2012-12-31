$ ->
  _gaq.push ["_trackEvent", "Launch", "Launch", "Launch"]
  $("#sql").submit ->
    _gaq.push ["_trackEvent", "Query Submitted", "Query Submitted", "Query Submitted"]
