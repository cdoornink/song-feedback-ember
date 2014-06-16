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
  $.get "http://ipinfo.io", ( (response) ->
      if callback
        if response.ip
          callback(response.ip) 
        else
          callback(new Date().getTime())
  ), "jsonp"
