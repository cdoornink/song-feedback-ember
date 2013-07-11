SF.MySongsController = Ember.ArrayController.extend
  songs: []

SF.SongsController = Ember.ArrayController.extend
  songs: []
  # leastRated: ->
#     #needs work, obviously

SF.ApplicationController = Ember.Controller.extend
  routeChanged: ( ->
    return unless window._gaq
    Em.run.next ->
      page = if window.location.hash.length > 0 then window.location.hash.substring(1) else window.location.pathname
      _gaq.push(['_trackPageview', page])
  ).observes('currentPath')