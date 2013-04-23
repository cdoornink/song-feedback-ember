SF.api = (req, type, data, callback) ->
  # url = "http://localhost:5000/"
  url = "http://nameless-beyond-8616.herokuapp.com/"
  console.log "make "+type+" request for "+req
  $.ajax
    url: url+req
    dataType: 'json'
    type: type
    data: data
    success: (response) -> callback(response) if response