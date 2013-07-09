SF.api = (req, type, data, callback) ->
  #url = "http://localhost:5000/"
  url = "http://nameless-beyond-8616.herokuapp.com/"
  $.ajax
    url: url+req
    dataType: 'json'
    type: type
    data: data
    success: (response) -> callback(response) if response and callback
    
SF.ip = (callback) ->
  $.ajax
    url: "http://jsonip.appspot.com/?callback=getip"
    type: "GET"
    dataType: 'json'
    complete: (r) ->
      jr = JSON.parse(r.responseText.substring(r.responseText.indexOf('{'),r.responseText.indexOf(')')))
      callback(jr.ip) if jr.ip and callback