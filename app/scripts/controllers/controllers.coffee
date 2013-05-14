SF.MySongsController = Ember.ArrayController.extend
  songs: []

SF.SongsController = Ember.ArrayController.extend
  songs: []
  leastRated: ->
    console.log "needs work"
        
SF.PlayerController = Ember.ObjectController.extend
  content: null
  playSong: (song) ->
    @set('content', song)
    @expandPlayer()
  expandPlayer: ->
    $(".player").addClass("expanded")
  compressPlayer: ->
    $(".player").removeClass("expanded")
  togglePlayerView: ->
    if $(".player").css("height") is "300px" then @compressPlayer() else @expandPlayer()

SF.playerController = SF.PlayerController.create()
        
