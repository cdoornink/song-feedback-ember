SF.api = (req, type, data, callback) ->
  #url = "http://localhost:5000/"
  url = "http://nameless-beyond-8616.herokuapp.com/"
  console.log "make "+type+" request for "+req
  $.ajax
    url: url+req
    dataType: 'json'
    type: type
    data: data
    success: (response) -> callback(response) if response
    
SF.ip = (callback) ->
  console.log "make get request for ip"
  $.ajax
    url: "http://jsonip.appspot.com/?callback=getip"
    type: "GET"
    dataType: 'json'
    complete: (r) ->
      jr = JSON.parse(r.responseText.substring(r.responseText.indexOf('{'),r.responseText.indexOf(')')))
      callback(jr.ip) if jr.ip 